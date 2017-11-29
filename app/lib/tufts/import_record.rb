module Tufts
  ##
  # A record for import.
  #
  # Instances are in-memory representations of records from import
  # documents, prepared for import into Fedora. In addition to the metadata
  # present in the final record, several other pieces of data are provided
  # to the import record to aid in importing the correct files and types.
  #
  # @example
  #   record      = ImportRecord.new
  #   record.file = 'filename.png'
  #
  class ImportRecord
    include Tufts::Normalizer

    VISIBILITY_VALUES =
      [Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
       Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO,
       Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_LEASE,
       Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
       Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE].freeze

    ##
    # @!attribute mapping [rw]
    #   @return [MiraXmlMapping]
    # @!attribute metadata [rw]
    #   @return [Nokogiri::XML::Node, nil]
    # @!attribute file [rw]
    #   @return [String]
    attr_accessor :mapping, :metadata
    attr_writer   :file

    ##
    # @param metadata [Nokogiri::XML::Node, nil]
    def initialize(metadata: nil, mapping: MiraXmlMapping.new)
      @mapping  = mapping
      @metadata = metadata
    end

    ##
    # @return [String, nil]
    def id
      return nil if metadata.nil?

      metadata.xpath('./tufts:id', mapping.namespaces)
              .children.map(&:content).first
    end

    ##
    # @return [Class] The model given by model:hasModel; GenericObject if none.
    def object_class
      return GenericObject if metadata.nil?

      name = metadata.xpath('./model:hasModel', mapping.namespaces).children.first

      name ? name.content.constantize : GenericObject
    end

    ##
    # @return [String]
    def file
      return '' if files.empty?

      files.first
    end

    ##
    # @return [Array<String>]
    def files
      return [] if metadata.nil?

      metadata
        .xpath('./tufts:filename', mapping.namespaces)
        .children
        .map(&:content)
    end

    ##
    # @return [String]
    def title
      return file if metadata.nil?

      @title ||=
        metadata.xpath('./dc:title', mapping.namespaces)
                .children.map(&:content).first || file
    end

    ##
    # @return [ActiveFedora::Core] a tufts model
    def build_object(id: self.id)
      attributes = fields.each_with_object({}) do |field, attrs|
        attrs[field.first] = field.last
      end

      return object_class.new(visibility: visibility, **attributes) unless id

      begin
        object = object_class.find(id)
        object.assign_attributes(attributes)
        object
      rescue ActiveFedora::ObjectNotFoundError
        object_class.new(id: id, visibility: visibility, **attributes)
      end
    end

    def fields
      return [].to_enum        unless metadata
      return enum_for(:fields) unless block_given?

      mapping.map do |field|
        case field.property
        when :title
          yield [:title, Array.wrap(title)]
        when :id, :has_model, :create_date, :modified_date, :head, :tail
          next
        else
          values = values_for(field: field)
          next unless values
          yield [field.property, values]
        end
      end
    end

    ##
    # @return [String]
    def visibility
      default = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

      return default if metadata.nil?

      visibilities = metadata.xpath('./tufts:visibility', mapping.namespaces)

      return default if visibilities.empty?

      visibility_text = visibilities.first.content
      return visibility_text if VISIBILITY_VALUES.include?(visibility_text)

      raise VisibilityError
    end

    class VisibilityError < ArgumentError; end

    private

      def singular_properties
        @singular_properties =
          GenericObject
          .properties.select { |_, cf| cf.try(:multiple?) == false }
          .keys.map(&:to_sym)
      end

      def values_for(field:)
        values =
          metadata
          .xpath("./#{field.namespace}:#{field.name}", @mapping.namespaces)
          .children
        return nil if values.empty?

        values = values.map(&:content)
        values = values.first if singular_properties.include?(field.property)
        values = normalize_import_field(field, values)
        values
      end
  end
end
