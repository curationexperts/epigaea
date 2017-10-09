module Tufts
  ##
  # A service for creating a persistent resource based on a
  # `Hyrax::UploadedFile` and an associated `XmlImport`.
  #
  # @example
  #   ImportService.import_object!(import:    my_import,
  #                                file:      import_file,
  #                                object_id: 'a_fedora_id')
  class ImportService
    ##
    # @!attribute file [rw]
    #   @return [Hyrax::UploadedFile]
    # @!attribute import [rw]
    #   @return [XmlImport]
    # @!attribute object_id [rw]
    #   @return [String]
    attr_accessor :file, :import, :object_id

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    #
    # @return [ActiveFedora::Core]
    # @see #import_object!
    def self.import_object!(import:, file:, object_id: nil)
      new(import: import, file: file, object_id: object_id).import_object!
    end

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    def initialize(file:, import:, object_id: nil)
      @file      = file
      @import    = import
      @object_id = object_id
    end

    ##
    # Imports the object.
    #
    # @return [ActiveFedora::Core]
    def import_object!
      object     = record.build_object(id: object_id)
      creator    = User.find(file.user_id)
      ability    = ::Ability.new(creator)
      attributes = { uploaded_files: [file.id] }
      env        = Hyrax::Actors::Environment.new(object, ability, attributes)

      Hyrax::CurationConcern.actor.create(env)
      object
    end

    ##
    # @return [ImportRecord]
    def record
      # UploadedFile -> Uploader -> CarrierWave::SanitizedFile -> String
      import.record_for(file: file.file.file.filename)
    end
  end
end
