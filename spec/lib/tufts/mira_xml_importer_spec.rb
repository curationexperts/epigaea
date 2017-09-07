require 'rails_helper'

RSpec.describe Tufts::MiraXmlImporter do
  subject(:importer) { described_class.new(file: file) }
  let(:file)         { File.open(file_fixture('mira_xml.xml')) }

  it { is_expected.to have_attributes file: file }

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
      expect(importer.records.map(&:file)).to contain_exactly('1.pdf', '2.pdf')
    end

    context 'with empty file' do
      let(:file) { StringIO.new('') }

      it 'yields nothing' do
        expect { |b| importer.records(&b) }.not_to yield_control
      end

      it 'returns an empty enumerable' do
        expect(importer.records.to_a).to be_empty
      end
    end
  end
end
