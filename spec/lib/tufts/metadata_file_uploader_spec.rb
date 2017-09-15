require 'rails_helper'

RSpec.describe Tufts::MetadataFileUploader do
  subject(:uploader) { described_class.new(model, :metadata_file) }
  let(:file)         { StringIO.new('moomin') }
  let(:model)        { FactoryGirl.create(:xml_import) }

  it 'is a carrierwave uploader' do
    expect(uploader).to be_a CarrierWave::Uploader::Base
  end
end
