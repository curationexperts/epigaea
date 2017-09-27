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
    #
    # @return [ImportRecord] a record from the import matching the file;
    #   A new empty ImportRecord is returned if none match
    def record_for(file:)
      records.find { |record| record.file == file } || ImportRecord.new
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
                            .children.map(&:content).first || ''
          record.title = node.xpath('./dc:title', node.namespaces)
                             .children.map(&:content).first || record.file

          yield record
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
