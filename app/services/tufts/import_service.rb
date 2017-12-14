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
    # @!attribute files [rw]
    #   @return [Array<Hyrax::UploadedFile>]
    # @!attribute import [rw]
    #   @return [XmlImport]
    # @!attribute object_id [rw]
    #   @return [String]
    attr_accessor :file, :files, :import, :object_id

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    #
    # @return [ActiveFedora::Core]
    # @see #import_object!
    def self.import_object!(import:, file: nil, object_id: nil, files: [])
      new(import: import, file: file, object_id: object_id, files: files).import_object!
    end

    ##
    # @param file   [Hyrax::UploadedFile]
    # @param import [XmlImport]
    def initialize(import:, file: nil, files: [], object_id: nil)
      if file
        warn 'Initializing ImportService with a single file is deprecated, ' \
             'use the `files` param instead'
      end

      @file      = file || files.first
      @import    = import
      @object_id = object_id
      @files     = files
    end

    ##
    # Imports the object.
    #
    # @return [ActiveFedora::Core]
    def import_object!
      object  = record.build_object(id: object_id)
      creator = User.find(file.user_id)
      ability = ::Ability.new(creator)
      env     = Hyrax::Actors::Environment.new(object, ability, attributes)

      Hyrax::CurationConcern.actor.create(env) ||
        raise(ImportError, "Failed to create object #{object.id}\n The actor stack returned `false`.")
      object
    end

    ##
    # @return [ImportRecord]
    def record
      # UploadedFile -> Uploader -> CarrierWave::SanitizedFile -> String
      import.record_for(file: file.file.file.filename)
    end

    class ImportError < RuntimeError; end

    private

      ##
      # @private
      # @return [HashWithIndifferentAccess]
      def attributes
        { uploaded_files:           file_ids,
          member_of_collection_ids: record.collections,
          thumbnail:                record.thumbnail,
          transcript:               record.transcript,
          representative:           record.representative }.with_indifferent_access
      end

      ##
      # @private
      def file_ids
        files.empty? ? [file.id] : files.map(&:id)
      end
  end
end
