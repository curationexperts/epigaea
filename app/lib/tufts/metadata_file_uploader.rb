require 'carrierwave'

module Tufts
  class MetadataFileUploader < CarrierWave::Uploader::Base
    storage :file

    ##
    # @see CarrierWave::Uploader::Base#filename
    def filename
      "#{token}.#{file.extension}" if original_filename.present?
    end

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

    private

      def token
        token_name = :"@#{mounted_as}_token"

        model.instance_variable_get(token_name) ||
          model.instance_variable_set(token_name, SecureRandom.uuid)
      end
  end
end
