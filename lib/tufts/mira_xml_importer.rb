module Tufts
  ##
  # An importer for MIRA XML.
  #
  # The import format is a stripped down OAI-PMH ListRecords response format.
  # Each `<record>` tag represents a single object.
  #
  # @example
  #   importer = MiraXmlImporter.new(file: File.open('my_import.xml'))
  #
  #
  # @see http://www.openarchives.org/OAI/openarchivesprotocol.html#ListRecords
  #   for the OAI ListRecords format.
  class MiraXmlImporter
    ##
    # @!ottribute file [rw]
    #   @return [IO]
    attr_accessor :file

    ##
    # @param [IO] file
    def initialize(file:)
      raise(ArgumentError, "file must be an IO, got a #{file.class}") unless
        file.respond_to? :read

      @file = file
    end

    ##
    # @yield Gives each record to the block
    # @yieldparam [ImportRecord]
    #
    # @return [Enumerable<ImportRecord>]
    def records
      if block_given?
        metadata_nodes.each do |node|
          record      = ImportRecord.new
          record.file = node.xpath('./dcterms:source', node.namespaces)
                            .children
                            .map(&:content)
                            .first || ''
          yield record
        end
      end

      enum_for(:records)
    end

    private

      def doc
        file.rewind
        Nokogiri::XML(file)
      end

      def metadata_nodes
        root = doc.root

        return [] if root.nil?

        root.xpath('//xmlns:record/xmlns:metadata/xmlns:mira_import',
                   root.namespaces)
      end
  end
end
