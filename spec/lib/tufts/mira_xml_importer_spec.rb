require 'rails_helper'

RSpec.describe Tufts::MiraXmlImporter do
  subject(:importer) { described_class.new(file: file) }
  let(:file)         { File.open(file_fixture('mira_xml.xml')) }

  it_behaves_like 'an importer'

  describe '#record?' do
    let(:filename) { 'pdf-sample.pdf' }

    it 'is true when a record matches the filename' do
      expect(importer.record?(file: filename)).to be true
    end

    it 'is false when no record matches' do
      expect(importer.record?(file: 'not-a-real-file.fake')).to be false
    end
  end

  describe '#record_for' do
    let(:filename) { 'pdf-sample.pdf' }

    it 'gives the record matching the filename' do
      expect(importer.record_for(file: filename).file).to eq filename
    end

    it 'gives an empty ImportRecord when no record matches' do
      expect(importer.record_for(file: 'not-a-real-file.fake').file).to be_empty
    end
  end

  describe '#records' do
    it 'yields correct number of records' do
      # yield once for each record in the sample file, excluding deleted records
      expect { |b| importer.records(&b) }
        .to yield_successive_args(an_instance_of(Tufts::ImportRecord),
                                  an_instance_of(Tufts::ImportRecord))
    end

    it 'returns the records' do
      expect(importer.records)
        .to contain_exactly(an_instance_of(Tufts::ImportRecord),
                            an_instance_of(Tufts::ImportRecord))
    end

    it 'populates records with files' do
      expect(importer.records.map(&:file)).to contain_exactly('pdf-sample.pdf', '2.pdf')
    end
  end

  describe 'validations' do
    context 'with missing filenames' do
      let(:file) { File.open(file_fixture('mira_xml_invalid.xml')) }

      it 'validates presence of filenames' do
        expect { importer.validate! }
          .to change { importer.errors }
          .to include(an_instance_of(Tufts::Importer::MissingFileError))
      end
    end

    context 'with duplicate filenames' do
      let(:file) { File.open(file_fixture('mira_xml_duplicate_filenames.xml')) }

      it 'validates presence of filenames' do
        expect { importer.validate! }
          .to change { importer.errors }
          .to include(an_instance_of(Tufts::Importer::DuplicateFileError))
      end
    end
  end
end
