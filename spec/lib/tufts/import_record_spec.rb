require 'rails_helper'

RSpec.describe Tufts::ImportRecord do
  subject(:record) { described_class.new }
  let(:id)         { 'IMPORT_RECORD_FAKE_ID' }
  let(:title)      { 'President Jean Mayer speaking at commencement, 1987' }

  shared_context 'with metadata' do
    subject(:record) { described_class.new(metadata: node) }

    let(:doc) { Nokogiri::XML(File.open(file_fixture('mira_xml.xml')).read) }

    let(:node) do
      doc.root.xpath('//xmlns:record/xmlns:metadata/xmlns:mira_import',
                     doc.root.namespaces).first
    end
  end

  describe '#build_object' do
    it 'builds a GenericObject by default' do
      expect(record.build_object).to be_a GenericObject
    end

    it 'can accept an id' do
      expect(record.build_object(id: id)).to have_attributes(id: id)
    end

    it 'can defer on id' do
      object       = record.build_object
      object.title = [title] # make object valid

      expect { object.save }
        .to change { object.id }
        .from(nil).to(an_instance_of(String))
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'assigns metadata' do
        expect(record.build_object)
          .to have_attributes(title: [title], creator: ['Unknown'])
      end
    end
  end

  describe '#id' do
    it 'is nil by default' do
      expect(record.id).to be_nil
    end

    context 'with metadata' do
      include_context 'with metadata'

      let(:doc) do
        Nokogiri::XML(File.open(file_fixture('mira_export.xml')).read)
      end

      it 'has an id' do
        expect(record.id).to eq '7s75dc36z'
      end
    end
  end

  describe '#metadata' do
    it 'is nil by default' do
      expect(record.metadata).to be_nil
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'has a title' do
        expect(record.title).to eq title
      end
    end
  end

  describe '#fields' do
    it 'is empty' do
      expect(record.fields.to_a).to be_empty
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'has metadata' do
        expect(record.fields.to_a).not_to be_empty
      end
    end
  end

  describe '#file' do
    it 'is an empty string by default' do
      expect(record.file).to eq ''
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'has a filename' do
        expect(record.file).to eq 'pdf-sample.pdf'
      end
    end
  end
end
