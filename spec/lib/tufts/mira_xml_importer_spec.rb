require 'rails_helper'

RSpec.describe Tufts::MiraXmlImporter do
  subject(:importer) { described_class.new(file: file) }
  let(:file)         { File.open(file_fixture('mira_xml.xml')) }

  it_behaves_like 'an importer'

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
  end
end
