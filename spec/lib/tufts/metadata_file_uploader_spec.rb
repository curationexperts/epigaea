require 'rails_helper'

RSpec.describe Tufts::MetadataFileUploader do
  subject(:uploader) { described_class.new(model, :metadata_file) }
  let(:file)         { StringIO.new('moomin') }
  let(:model)        { FactoryGirl.create(:xml_import) }

  before do
    allow(Collection).to receive(:find).and_return(true)
  end

  it 'is a carrierwave uploader' do
    expect(uploader).to be_a CarrierWave::Uploader::Base
  end

  describe '#filename' do
    let(:other_model)    { FactoryGirl.create(:xml_import) }
    let(:other_uploader) { described_class.new(other_model, :metadata_file) }
    let(:test_file)      { File.open(file_fixture('mira_xml.xml')) }

    it 'generates a filename for uploads' do
      expect { uploader.store!(test_file) }
        .to change { uploader.file }
        .from(nil)
    end

    it 'generates a filename is different for multiple uploads' do
      uploader.store!(test_file)
      other_uploader.store!(test_file)

      expect(uploader.filename).not_to eq other_uploader.filename
    end

    it 'retains the generated filename' do
      uploader.store!(test_file)

      expect { model.reload }.not_to change { uploader.filename }
    end
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
