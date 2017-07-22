require 'rails_helper'

# rubocop:disable RSpec/MessageSpies, Lint/HandleExceptions, RSpec/InstanceVariable
describe Tufts::HandleRegistrar do
  subject(:service) do
    described_class.new(connection: stubbed_connection.new(record: record))
  end

  let(:object) { build(:pdf) }
  let(:admin)  { '0.NA/10427.TEST' }
  let(:email)  { 'brian.goodmon@tufts.edu' }
  let(:record) { Handle::Record.new }
  let(:url)    { "http://dl.tufts.edu/catalog/#{object.id}" }

  let(:fake_builder) do
    # a builder that always returns the same handle
    Class.new do
      def build
        'hdl/hdl1'
      end
    end
  end

  # rubocop:disable Style/MethodMissing
  let(:stubbed_connection) do
    # A connection that returns the handle record given on initialzation
    Class.new do
      def initialize(*, record:)
        @record = record
      end

      def create_record(handle)
        @record.handle     = handle
        @record.connection = self
        @record
      end

      # responnd to everything and do nothing.
      def method_missing(*); end # no-op

      def respond_to_missing?(*)
        true
      end
    end
  end

  before { allow(record).to receive(:save).and_return(true) }

  describe '#register!' do
    context 'when the object lacks a stable id' do
      let(:object) { Pdf.new }

      it 'logs an error' do
        expect(described_class::LOGGER).to receive(:log)

        begin
          service.register!(object: object)
        rescue described_class::NullIdError; end # no-op
      end

      it 'reraises the error' do
        expect { service.register!(object: object) }
          .to raise_error described_class::NullIdError
      end
    end

    context 'when there is an error registering the handle' do
      subject(:service) do
        described_class.new(connection: error_connection.new,
                            builder:    fake_builder.new)
      end

      let(:error_connection) do
        # a connection that returns an error for any methods
        Class.new do
          def method_missing(*)
            raise Handle::HandleError, 'Invalid admin'
          end

          def respond_to_missing?(*)
            true
          end
        end
      end

      # rubocop:disable RSpec/ExampleLength
      it 'logs errors' do
        message = "Unable to register handle hdl/hdl1 for #{object.uri}\n" \
                  "Invalid admin"

        expect(described_class::LOGGER)
          .to receive(:log).with(nil, object.uri, message)

        begin
          service.register!(object: object)
        rescue Handle::HandleError; end # no-op
      end

      it 're-raises errors' do
        expect { service.register!(object: object) }
          .to raise_error Handle::HandleError, "Invalid admin"
      end

      it 'results in blank identifier' do
        begin
          service.register!(object: object)
        rescue Handle::HandleError; end # no-op

        expect(object.identifier).to be_blank
      end
    end

    it 'returns a record with a handle' do
      record = service.register!(object: object)
      expect(record.handle).to match(/.+\/.+/)
    end

    it 'saves the record' do
      expect(record).to receive(:save).and_return(true)
      service.register!(object: object)
    end

    it 'has url metadata' do
      expect(service.register!(object: object).to_batch)
        .to include "2 URL 86400 1110 UTF8 #{url}"
    end

    it 'has email metadata' do
      expect(service.register!(object: object).to_batch)
        .to include "6 EMAIL 86400 1110 UTF8 #{email}"
    end

    it 'has hs_admin metadata' do
      expect(service.register!(object: object).to_batch)
        .to include "100 HS_ADMIN 86400 1110 ADMIN 300:111111111111:#{admin}"
    end
  end

  describe '#update!' do
    it 'updates the email'
    it 'updates the URL'
  end
end
