require 'rails_helper'

RSpec.describe Tufts::MiraXmlMapping do
  subject(:mapping) { described_class.new }

  describe '#namespaces' do
    it 'has dc' do
      expect(mapping.namespaces).to have_key 'xmlns:dc'
    end

    it 'has valid uris for values' do
      mapping.namespaces.each_value do |value|
        expect(RDF::URI(value)).to be_valid
      end
    end
  end
end
