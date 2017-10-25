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
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
    def build
      @xml ||= Nokogiri::XML::Builder.new do |xml|
        xml.send(:'OAI-PMH',
                 'xmlns' => 'http://www.openarchives.org/OAI/2.0/') do
          xml.ListRecords do
            @objects.each do |object|
              xml.record do
                xml.metadata do
                  xml.mira_import(@mapping.namespaces) do
                    @mapping.map_sorted do |field|
                      if field.property == :id
                        xml[field.namespace.to_s]
                          .send(field.name, object.send(field.property))
                        next
                      end

                      values = object.resource.get_values(field.property)
                      values = field.filter.call(values) if field.filter

                      Array(values).each do |value|
                        attributes = {}

                        if value.respond_to? :to_term
                          attributes[:uri] = value.to_term
                          value            = value.rdf_label.first
                        else
                          datatype = RDF::Literal(value).datatype
                          attributes[:datatype] = datatype unless
                            datatype == RDF::XSD.string
                        end

                        xml[field.namespace.to_s].send(field.name, value, **attributes)
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
