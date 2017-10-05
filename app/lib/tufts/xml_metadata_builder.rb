module Tufts
  ##
  # A builder class for constructing XML metadata exports
  class XmlMetadataBuilder
    FILE_EXT = '.xml'.freeze

    ##
    # @return [String] the built metadata for export
    def build
      'temporary fake xml'
    end

    def file_extension
      FILE_EXT
    end
  end
end
