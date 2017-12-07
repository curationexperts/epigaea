require 'rails_helper'

RSpec.describe Tufts::ResourceTypeService do
  describe '.label' do
    let(:id)    { 'http://purl.org/dc/dcmitype/Collection' }
    let(:label) { 'Collection' }

    it 'finds the label of a known property' do
      expect(described_class.label(id)).to eq label
    end

    it 'raises an error for an unknown property' do
      expect { described_class.label('NOT A REAL TERM') }.to raise_error described_class::LookupError
    end
  end
end
