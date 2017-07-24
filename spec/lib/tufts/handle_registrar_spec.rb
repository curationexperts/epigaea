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
      def build(*)
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

      # Always return the specified handle
      def create_record(handle)
        @record.handle     = handle
        @record.connection = self
        @record
      end

      # Resolve to the specified handle for `hdl/hdl1',
      # raise NotFound otherwise
      def resolve_handle(handle, *)
        raise Handle::NotFound unless handle == 'hdl/hdl1'
        create_record(handle)
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
        message = "Unable to register handle hdl/hdl1 for #{object.id}\n" \
                  "Invalid admin"

        expect(described_class::LOGGER)
          .to receive(:log).with(nil, object.id, message)

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

    it 'returns a record with a handle using the configured prefix' do
      record = service.register!(object: object)
      expect(record.handle).to match(/tufts\.test\/.+/)
    end

    it 'generates different handles for different objects' do
      other = build(:pdf)

      expect(service.register!(object: object).handle)
        .not_to eq service.register!(object: other).handle
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
    context 'when handle is not registered' do
      it 'raises Handle::NotFound' do
        expect { service.update!(handle: 'hdl/not_a_handle', object: object) }
          .to raise_error Handle::NotFound
      end
    end

    context 'without changes' do
      before { service.update_record(object: object, record: record) }

      it 'does not save the record' do
        expect(record).not_to receive(:save)
        service.update!(handle: 'hdl/hdl1', object: object)
      end
    end

    context 'when changes have been made' do
      before { record.add(:URL, 'http://example.com/fake').index = 2 }

      it 'saves the record' do
        expect(record).to receive(:save).and_return(true)
        service.update!(handle: 'hdl/hdl1', object: object)
      end

      it 'updates hs_admin' do
        expect(service.update!(handle: 'hdl/hdl1', object: object).to_batch)
          .to include "100 HS_ADMIN 86400 1110 ADMIN 300:111111111111:#{admin}"
      end

      it 'updates the email' do
        expect(service.update!(handle: 'hdl/hdl1', object: object).to_batch)
          .to include "6 EMAIL 86400 1110 UTF8 #{email}"
      end

      it 'updates URL' do
        expect(service.update!(handle: 'hdl/hdl1', object: object).to_batch)
          .to include "2 URL 86400 1110 UTF8 #{url}"
      end

      it 'deletes old fields URL' do
        expect(service.update!(handle: 'hdl/hdl1', object: object).to_batch)
          .not_to include "2 URL 86400 1110 UTF8 http://example.com/fake"
      end
    end
  end
end
