require 'rails_helper'

RSpec.describe Tufts::Importer do
  let(:file) do
    File.open(File.join(fixture_path, 'files', 'mira_xml.xml'), 'r')
  end

  after do
    file.close
  end

  it_behaves_like 'an importer'

  describe '.for' do
    it 'gives an importer instance' do
      expect(described_class.for(file: file)).to be_a described_class
    end
  end

  describe '#initialize' do
    let(:badly_formed_xml) do
      File.open(File.join(fixture_path, 'files', 'malformed_files', 'stray_element.xml'), 'r')
    end

    after do
      badly_formed_xml.close
    end

    it "reports parsing errors if the document contains a stray element" do
      importer = described_class.new(file: badly_formed_xml)
      expect(importer.errors).not_to be_empty
    end
  end

  describe described_class::Error do
    subject(:error) { described_class.new(lineno, details) }
    let(:details)   { { type: 'serious' } }
    let(:lineno)    { 27 }

    describe '#message' do
      it 'has the line number' do
        expect(error.message).to include lineno.to_s
      end

      it 'has the details' do
        expect(error.message).to include 'type: serious'
      end
    end
  end
end
