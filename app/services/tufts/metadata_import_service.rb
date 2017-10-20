module Tufts
  ##
  # A service for updating a persistent resource based on a `MetadataImport`.
  #
  # @example
  #   Tufts::MetadataImportService.import_object!(import:    import,
  #                                               object_id: object)
  class MetadataImportService
    ##
    # @!attribute import [rw]
    #   @return [XmlImport]
    # @!attribute object_id [rw]
    #   @return [String]
    attr_accessor :import, :object_id

    ##
    # @param import    [MetadataImport]
    # @param object_id [String]
    #
    # @return [ActiveFedora::Core]
    # @see #update_object!
    def self.update_object!(import:, object_id:)
      new(import: import, object_id: object_id).update_object!
    end

    ##
    # @param import    [MetadataImport]
    # @param object_id [String]
    def initialize(import:, object_id:)
      @import    = import
      @object_id = object_id
    end

    ##
    # Updates the object
    #
    # @return [ActiveFedora::Core]
    def update_object!
      object = import.record_for(id: object_id).build_object
      object.save!
    end
  end
end
