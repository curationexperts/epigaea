module Tufts
  ##
  # A record for import.
  #
  # Instances are in-memory representations of records from import
  # documents, prepared for import into Fedora. In addition to the metadata
  # present in the final record, several other pieces of data are provided
  # to the import record to aid in importing the correct files and types.
  #
  # @example
  #   record      = ImportRecord.new
  #   record.file = 'filename.png'
  #
  class ImportRecord
    ##
    # @!attribute file [rw]
    #   @return [String]
    attr_accessor :file

    ##
    # @param file [String]
    def initialize(file: '')
      @file = file
    end

    ##
    # @return [ActiveFedora::Core] a tufts model
    def build_object
      visibility =
        Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      GenericObject.new(title: [file], visibility: visibility)
    end
  end
end
