module Tufts
  ##
  # A generic (empty) importer.
  #
  # @example defining and registering a new importer
  #   class MyImporter < Importer
  #     def self.match?(**opts)
  #
  #     end
  #   end
  #
  # @example using the factory and accessing methods
  #   importer = Tufts::Importer.for(file: 'moomin.xml')
  #   importer.records
  #
  class Importer
    ##
    # @!attribute file [rw]
    #   @return [IO]
    attr_accessor :file

    @subclasses = [] # @private

    class << self
      ##
      # @return [Importer]
      def for(file:)
        klass = @subclasses.find { |k| k.match?(filename: file) } || self

        klass.new(file: file)
      end

      ##
      # @param   opts [Hash]
      # @options filename [String]
      #
      # @return [Boolean]
      def match?(**_opts)
        false
      end

      private

      ##
      # @private Register new class when inherited
      def inherited(other)
        @subclasses << other
        super
      end
    end

    ##
    # @param file [IO]
    def initialize(file:)
      raise(ArgumentError, "file must be an IO, got a #{file.class}") unless
        file.respond_to? :read
      @file = file
    end

    ##
    # @return [Array<Error>]
    def errors
      @errors ||= []
    end

    ##
    # @yield Gives each record to the block
    # @yieldparam [ImportRecord]
    #
    # @return [Enumerable<ImportRecord>]
    def records
      []
    end

    ##
    # Validates the file. Returns false and populates errors when invalid.
    #
    # At least one error must be added for an invalid file.
    #
    # @return [Enumerable<Error>]
    # @see #errors
    def validate!(import_type = 'xml')
      @import_type = import_type
      check_for_well_formed_xml(@file.read)
      validate_filenames unless @import_type == 'metadata'
      errors
    end

    ##
    # A generic error class for errors in import files.
    #
    # @example
    #   err = Importer::Error.new(27, type: :serious)
    #
    #   err.message
    #   # => "An error occured parsing the file at line: 27; (type: serious)"
    #
    class Error < StandardError
      ##
      # @param line    [Integer]
      # @param details [Hash<#to_s, #to_s>]
      def initialize(line = nil, details = {})
        @line    = line
        @details = details

        super(message)
      end

      ##
      # @private
      # @return [String]
      def present_details
        return '' if @details.empty?
        '(' + @details.map { |k, v| "#{k}: #{v}" }.join(', ') + ')'
      end

      ##
      # @private
      # @return [String]
      def present_line
        (@line || 'Unknown Line').to_s
      end

      ##
      # @return [String]
      def message
        "An error occured parsing the file at line: #{present_line}; #{present_details}"
      end
    end

    class MissingFileError < Error
      ##
      # @return [String]
      def message
        "A file was missing for the record at line: #{present_line}; #{present_details}"
      end
    end

    class DuplicateFileError < Error
      ##
      # @return [String]
      def message
        "A duplicate filename `#{@details[:file]}` was found at line: #{present_line}; #{present_details}"
      end
    end

    private

      # Use Nokogiri's XML parser to check that the file is well formed
      # See http://www.nokogiri.org/tutorials/ensuring_well_formed_markup.html
      # Create a new Importer::Error for each error found by the Nokogiri parser
      def check_for_well_formed_xml(file)
        doc = Nokogiri::XML file
        if doc.errors.count > 0
          e = doc.errors.first
          errors << Importer::Error.new(e.line, type: :serious, message: "Malformed XML error: #{e.message}")
        end
        doc.root.add_namespace("dc", "http://purl.org/dc/terms/")
        doc.root.add_namespace("tufts", "http://dl.tufts.edu/terms#")
        doc.root.add_namespace("model", "info:fedora/fedora-system:def/model#")
        doc.xpath("//xmlns:record/xmlns:metadata/xmlns:mira_import").each do |record|
          check_for_required_fields(record)
          check_that_collections_exist(record)
          check_for_one_and_only_one_id(record) if @import_type == 'metadata'
          check_for_valid_ids(record) if @import_type == 'metadata'
        end
      end

      # Given a record, return the file or id that identifies it
      def file_or_id(record)
        return record.xpath('tufts:filename').text unless record.xpath('tufts:filename').text.blank?
        return record.xpath('tufts:id').text unless record.xpath('tufts:id').text.blank?
        "Unidentified record"
      end

      # Given a record, check that it has all required fields
      # @param [Nokogiri::XML::Element] record
      def check_for_required_fields(record)
        identifier = file_or_id(record)
        required_fields = ["dc:title", "tufts:displays_in", "model:hasModel"]
        required_fields.each do |field|
          if record.xpath(field).text.empty?
            errors << Importer::Error.new(record.line, type: :serious, message: "Missing required field: #{identifier} is missing #{field}")
          end
        end
      end

      # For each collection referenced by tufts:memberOf, ensure that
      # collection exists
      # @param [Nokogiri::XML::Element] record
      def check_that_collections_exist(record)
        return unless record.xpath("tufts:memberOf") && !record.xpath("tufts:memberOf").text.empty?
        identifier = file_or_id(record)
        record.xpath("tufts:memberOf").each do |collection_id|
          begin
            Collection.find(collection_id.text)
          rescue ActiveFedora::ObjectNotFoundError
            errors << Importer::Error.new(record.line, type: :serious, message: "Cannot find collection with id #{collection_id.text} for #{identifier}")
          end
        end
      end

      # Each metadata import record must have one and only one id
      # @param [Nokogiri::XML::Element] record
      def check_for_one_and_only_one_id(record)
        ids = record.xpath('tufts:id')
        if ids.count.zero?
          errors << Importer::Error.new(record.line, type: :serious, message: "An id field is required for each metadata import record")
        elsif ids.count > 1
          errors << Importer::Error.new(record.line, type: :serious, message: "Only one id field can be specified per metadata import record")
        end
      end

      # Each id in a metadata import record must refer to a real object
      # @param [Nokogiri::XML::Element] record
      def check_for_valid_ids(record)
        return if record.xpath('tufts:id').empty?
        id = record.xpath('tufts:id').first.text
        begin
          ActiveFedora::Base.find(id)
        rescue ActiveFedora::ObjectNotFoundError
          errors << Importer::Error.new(record.line, type: :serious, message: "#{id} is not a valid object id")
        end
      end

      ##
      # @private
      def validate_filenames
        records.each_with_object(Set.new) do |record, files_touched|
          errors << MissingFileError.new(record.metadata.line) if record.files.empty?
          record.files.each do |file|
            errors << DuplicateFileError.new(nil, file: file) unless
              files_touched.add?(file)
          end
        end
      end
  end
end
