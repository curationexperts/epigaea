require 'carrierwave'

module Tufts
  class MetadataFileUploader < CarrierWave::Uploader::Base
    storage :file

    ##
    # @see CarrierWave::Uploader::Base#store_dir
    def store_dir
      Rails.application.config.metadata_upload_dir.join('store').to_s
    end

    ##
    # @see CarrierWave::Uploader::Base#cache_dir
    def cache_dir
      Rails.application.config.metadata_upload_dir.join('cache').to_s
    end
  end
end
