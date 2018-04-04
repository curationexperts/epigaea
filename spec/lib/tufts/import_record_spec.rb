require 'rails_helper'

RSpec.describe Tufts::ImportRecord do
  subject(:record)   { described_class.new }
  let(:id)           { 'IMPORT_RECORD_FAKE_ID' }
  let(:title)        { "President Jean Mayer speaking\n          at commencement, 1987" }
  let!(:collections) { record.collections.map { |id| create(:collection, id: id) } }

  shared_context 'with metadata' do
    subject(:record) { described_class.new(metadata: node) }

    let(:doc) { Nokogiri::XML(File.open(file_fixture('mira_xml.xml')).read) }

    let(:node) do
      doc.root.xpath('//xmlns:record/xmlns:metadata/xmlns:mira_import',
                     doc.root.namespaces).first
    end
  end

  shared_context 'with file types' do
    include_context 'with metadata'

    let(:doc) { Nokogiri::XML(File.open(file_fixture('mira_xml_file_types.xml')).read) }

    let(:thumbnail_record) { described_class.new(metadata: thumbnail_node) }

    let(:thumbnail_node) do
      doc.root.xpath('//xmlns:record/xmlns:metadata/xmlns:mira_import', doc.root.namespaces)[1]
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

      let(:expected_attributes) do
        { title:                 [title],
          creator:               ['Unknown'],
          personal_name:         ['Mayer, Jean'],
          corporate_name:        ['Office of the President'],
          visibility:            'open',
          member_of_collections: collections }
      end

      it 'assigns metadata' do
        expect(record.build_object).to have_attributes(**expected_attributes)
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
        expect(record.id).to eq 'sx61dm28w'
      end
    end
  end

  describe '#collections' do
    it 'is empty by default' do
      expect(record.collections).to be_empty
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'has a collection' do
        expect(record.collections).to contain_exactly(an_instance_of(String),
                                                      an_instance_of(String))
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

      it 'normalized metadata fields' do
        expect(record.fields.to_a).to include([:abstract, ["Another long description with\n plenty\n of whitespace"]])
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

  describe '#visibility' do
    it 'default visibility is private' do
      expect(record.visibility)
        .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'uses specified visibility' do
        expect(record.visibility)
          .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end
  end

  describe '#transcript' do
    it 'is empty by default' do
      expect(record.transcript).to eq ''
    end

    context 'with no types' do
      include_context 'with metadata'

      it 'is empty' do
        expect(record.transcript).to eq ''
      end
    end

    context 'with file types' do
      include_context 'with file types'

      it 'has a transcript' do
        expect(record.transcript).to eq '2.pdf'
      end
    end
  end

  describe '#thumbnail' do
    it 'is empty by default' do
      expect(record.thumbnail).to eq ''
    end

    context 'with no types' do
      include_context 'with metadata'

      it 'is empty' do
        expect(record.thumbnail).to eq ''
      end
    end

    context 'with file types' do
      include_context 'with file types'

      it 'has a thumbnail' do
        expect(thumbnail_record.thumbnail).to eq 'fake.png'
      end
    end
  end

  describe '#representative' do
    it 'is empty by default' do
      expect(record.representative).to eq ''
    end

    context 'with no types' do
      include_context 'with metadata'

      it 'is empty' do
        expect(record.representative).to eq ''
      end
    end

    context 'with file types' do
      include_context 'with file types'

      it 'has a thumbnail' do
        expect(record.representative).to eq 'pdf-sample.pdf'
      end
    end
  end

  describe '#files' do
    it 'is an empty collection by default' do
      expect(record.files).to be_empty
    end

    context 'with metadata' do
      include_context 'with metadata'

      it 'uses specified visibility' do
        expect(record.visibility)
          .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end

      it 'has the filenames in order' do
        expect(record.files).to eq ['pdf-sample.pdf', '3.pdf']
      end
    end
  end
end
