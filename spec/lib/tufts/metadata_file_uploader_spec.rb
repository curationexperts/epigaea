require 'rails_helper'

RSpec.describe Tufts::MetadataFileUploader do
  subject(:uploader) { described_class.new(model, :metadata_file) }
  let(:file)         { StringIO.new('moomin') }
  let(:model)        { FactoryGirl.create(:xml_import) }

  it 'is a carrierwave uploader' do
    expect(uploader).to be_a CarrierWave::Uploader::Base
  end

  describe '#store_dir' do
    it 'is the configured directory' do
      expect(uploader.store_dir)
        .to eq Rails.root.join('tmp', 'metadata', 'store').to_s
    end
  end

  describe '#cache_dir' do
    it 'is the configured directory' do
      expect(uploader.cache_dir)
        .to eq Rails.root.join('tmp', 'metadata', 'cache').to_s
    end
  end
end
