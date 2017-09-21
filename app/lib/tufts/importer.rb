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

    private

      ##
      # @private
      def validate_filenames
        records.each do |record|
          errors << MissingFileError.new if
            record.file.nil? || record.file.empty?
        end
      end
  end
end
