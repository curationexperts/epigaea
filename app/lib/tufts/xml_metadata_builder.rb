module Tufts
  ##
  # A builder class for constructing XML metadata exports
  class XmlMetadataBuilder
    FILE_EXT = '.xml'.freeze

    def initialize
      @mapping = MiraXmlMapping.new
      @objects = []
    end

    ##
    # @param object [ActiveFedora::Base]
    def add(*objects)
      @objects.concat(objects) && @xml = nil
      @objects
    end

    ##
    # @return [String] the built metadata for export
    def build # rubocop:disable Metrics/MethodLength
      @xml ||= Nokogiri::XML::Builder.new do |xml|
        xml.send(:'OAI-PMH',
                 'xmlns' => 'http://www.openarchives.org/OAI/2.0/') do
          xml.ListRecords do
            @objects.each do |object|
              xml.record do
                xml.metadata do
                  xml.mira_import(@mapping.namespaces) do
                    @mapping.map do |field|
                      values = object.send(field.property)
                      values = field.filter.call(values) if field.filter

                      Array(values).each do |value|
                        xml[field.namespace.to_s].send(field.name, value)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end.to_xml
    end

    ##
    # @return [String]
    def file_extension
      FILE_EXT
    end
  end
end
