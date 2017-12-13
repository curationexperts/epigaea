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
    def validate!
      check_for_well_formed_xml(@file.read)
      validate_filenames
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
        end
      end

      # Given a record, check that it has all required fields
      def check_for_required_fields(record)
        required_fields = ["dc:title", "tufts:displays_in", "model:hasModel"]
        required_fields.each do |field|
          if record.xpath(field).text.empty?
            filename = record.xpath('tufts:filename').text || "Unknown filename"
            errors << Importer::Error.new(record.line, type: :serious, message: "Missing required field: #{filename} is missing #{field}")
          end
        end
      end

      def check_that_collections_exist(record)
        return unless record.xpath("tufts:memberOf") && !record.xpath("tufts:memberOf").text.empty?
        record.xpath("tufts:memberOf").each do |collection_id|
          begin
            Collection.find(collection_id.text)
          rescue ActiveFedora::ObjectNotFoundError
            filename = record.xpath('tufts:filename').text || "Unknown filename"
            errors << Importer::Error.new(record.line, type: :serious, message: "Cannot find collection with id #{collection_id.text} for filename #{filename}")
          end
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
