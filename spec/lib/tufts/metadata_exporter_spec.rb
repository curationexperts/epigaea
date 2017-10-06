require 'rails_helper'

RSpec.describe Tufts::MetadataExporter do
  subject(:exporter) { described_class.new(ids: ids, builder: builder) }
  let(:builder)      { fake_builder.new }
  let(:ids)          { models.map(&:id) }
  let(:models)       { FactoryGirl.create_list(:generic_object, 3) }

  let(:fake_builder) do
    Class.new do
      def fake_metadata
        'some super fake metadata'
      end

      def add(*); end

      def build
        fake_metadata
      end

      def file_extension
        '.fake'
      end
    end
  end

  define :read_as do |expected|
    match { |actual| actual.read == expected }
  end

  it { is_expected.to have_attributes(ids: ids, builder: builder) }

  after { exporter.cleanup! }

  describe '#builder' do
    it 'defaults to an xml metadata builder' do
      expect(described_class.new(ids: ids))
        .to have_attributes(builder: an_instance_of(Tufts::XmlMetadataBuilder))
    end
  end

  describe '#export' do
    it 'contains built metadata' do
      expect(exporter.export).to read_as(builder.fake_metadata)
    end
  end

  describe '#export!' do
    it 'writes built metadata to a file' do
      expect { exporter.export! }
        .to change { exporter.file }
        .from(nil).to(read_as(builder.fake_metadata))
    end
  end

  describe '#file' do
    it 'is nil export' do
      expect(exporter.file).to be_nil
    end

    context 'after export' do
      before { exporter.export! }

      it 'contains built metadata' do
        expect(exporter.file).to read_as(builder.fake_metadata)
      end

      it 'yields a file containing built metadata' do
        expect { |b| exporter.file(&b) }
          .to yield_with_args(read_as(builder.fake_metadata))
      end

      it 'gives the same file from a new instance' do
        new_exporter =
          described_class.new(ids: ids, builder: builder, name: exporter.name)

        expect(new_exporter.file).to read_as(builder.fake_metadata)
      end
    end
  end
end
