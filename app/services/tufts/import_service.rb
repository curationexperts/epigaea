module Tufts
  ##
  # A service for creating a persistent resource based on a
  # `Hyrax::UploadedFile` and an associated `XmlImport`.
  #
  # @example
  #   ImportService.new
  class ImportService
    ##
    # @!attribute file [rw]
    #   @return [Hyrax::UploadedFile]
    # @!attribute import [rw]
    #   @return [XmlImport]
    attr_accessor :file, :import

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    #
    # @return [ActiveFedora::Core]
    # @see #import_object!
    def self.import_object!(import:, file:)
      new(import: import, file: file).import_object!
    end

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    def initialize(file:, import:)
      @file   = file
      @import = import
    end

    ##
    # Imports the object.
    #
    # @return [ActiveFedora::Core]
    def import_object!
      object     = record.build_object
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
      filename = file.file.file.filename

      import.record_for(file: filename)
    end
  end
end
