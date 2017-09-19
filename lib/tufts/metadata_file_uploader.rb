require 'carrierwave'

module Tufts
  class MetadataFileUploader < CarrierWave::Uploader::Base
    storage :file
  end
end
