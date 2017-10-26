module Tufts
  ##
  # Defines a mapping between GenericObject metadata and custom mira XML.
  class MiraXmlMapping
    ##
    # A sturct representing a metadata field
    #
    # @example
    #   field = Field.new('dc', 'title', :title)
    #
    #   field.namespace # => 'dc'
    #   field.name      # => 'title'
    #   field.property  # => :title
    #
    Field = Struct.new(:namespace, :name, :property, :filter)

    SKIP_FIELDS = [:head, :tail, :create_date, :modified_date,
                   :depositor, :proxy_depositor, :on_behalf_of,
                   :state, :arkivo_checksum, :owner].freeze

    PROPERTIES = GenericObject.properties
                              .reject { |k, _| SKIP_FIELDS.include?(k.to_sym) }
                              .values
                              .freeze

    FILTERS = { title: Proc.new(&:first) }.freeze

    ##
    # @yield Yields each field in the mapped object
    # @yieldparam
    #
    # @return [Enumerator<Field>]
    def map
      if block_given?
        yield Field.new('tufts', 'id', :id, FILTERS['id'])

        PROPERTIES.each do |node_config|
          term     = node_config.term
          ns, name = node_config.predicate.qname
          next if ns.nil?
          yield Field.new(ns, name, term, FILTERS[term])
        end
      end

      enum_for(:map)
    end

    ##
    # Maps in a sorted order for easy reading.
    #
    # @see #map
    def map_sorted(&block)
      map.sort_by { |field| "#{field.namespace}:#{field.name}" }
         .each(&block)
    end

    ##
    # @return [Hash<String, String>]
    def namespaces
      @namespaces ||= PROPERTIES.each_with_object({}) do |node_config, hsh|
        predicate = node_config.predicate
        ns, name  = predicate.qname
        next if ns.nil?
        ns_uri = predicate.to_s[0...-name.length]

        hsh["xmlns:#{ns}"] = ns_uri
      end
    end

    ##
    # Define namespaces for qnames. RDF::URI uses Vocabulary to handle qnames
    # selection, so this maps to `xmlns:scholarsphere` and `xmlns:opaquehydra`
    class Scholarsphere < RDF::Vocabulary('http://scholarsphere.psu.edu/ns#'); end
    class OpaqueHydra < RDF::Vocabulary('http://opaquenamespace.org/ns/hydra/'); end
  end
end
