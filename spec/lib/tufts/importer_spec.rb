require 'rails_helper'

RSpec.describe Tufts::Importer do
  let(:file) { StringIO.new('blah') }

  it_behaves_like 'an importer'

  describe '.for' do
    it 'gives an importer instance' do
      expect(described_class.for(file: file)).to be_a described_class
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
