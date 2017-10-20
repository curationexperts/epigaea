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
  # @see http://www.openarchives.org/OAI/openarchivesprotocol.html#ListRecords
  #   for the OAI ListRecords format.
  class MiraXmlImporter < Importer
    ##
    # @note This class matches all files. If new import formats are added, the
    #   logic of this method should change.
    #
    # @param   opts [Hash]
    # @options filename [String]
    #
    # @return [Boolean]
    def self.match?(**_opts)
      true
    end

    ##
    # @param file [String]
    # @param id   [String]
    #
    # @return [ImportRecord] a record from the import matching the file;
    #   A new empty ImportRecord is returned if none match
    def record_for(file: nil, id: nil)
      (file && records.find { |record| record.file == file }) ||
        (id && records.find { |record| record.id == id }) ||
        ImportRecord.new
    end

    ##
    # @param file [String]
    #
    # @return [Boolean]
    def record?(file:)
      records.any? { |record| record.file == file }
    end

    ##
    # @yield Gives each record to the block
    # @yieldparam [ImportRecord]
    #
    # @return [Enumerable<ImportRecord>]
    def records
      if block_given?
        mapping = MiraXmlMapping.new

        metadata_nodes.each do |node|
          yield ImportRecord.new(metadata: node, mapping: mapping)
        end
      end

      enum_for(:records)
    end

    private

      def doc
        file.rewind if file.respond_to? :rewind
        Nokogiri::XML(file.read)
      end

      def metadata_nodes
        root = doc.root

        return [] if root.nil?

        root.xpath('//xmlns:record/xmlns:metadata/xmlns:mira_import',
                   root.namespaces)
      end
  end
end
