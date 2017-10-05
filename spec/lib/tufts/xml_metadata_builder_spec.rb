require 'rails_helper'

RSpec.describe Tufts::XmlMetadataBuilder do
  subject(:builder) { described_class.new }

  it_behaves_like 'a MetadataBuilder'

  describe '#file_extension' do
    it 'is .xml' do
      expect(builder.file_extension).to eq '.xml'
    end
  end
end
