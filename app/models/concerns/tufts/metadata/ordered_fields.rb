module Tufts
  module Metadata
    module OrderedFields
      extend ActiveSupport::Concern
      included do
        # A property to preserve the order of descriptions.  Don't set the value of this property directly.  It will be kept in sync by the setter method for the 'description' property.
        property :ordered_descriptions, predicate: ::Tufts::Vocab::Tufts.ordered_descriptions, multiple: false do |index|
          index.as :symbol
        end

        # No other properties can be defined below
        # this point because Hyrax::BasicMetadata uses
        # accepts_nested_attributes_for, which will
        # finalize the metadata schema.
        # https://github.com/samvera/active_fedora/issues/847
        include Hyrax::BasicMetadata

        # @param [Array] Ordered array of values
        # Overrides setter method to preserve order in a second property.
        def description=(values)
          self.ordered_descriptions = values.to_json
          super
        end

        # @return [Array<String>]
        # Overrides getter method to return the descriptions in the correct order.
        def description
          if ordered_descriptions.blank?
            super
          else
            JSON.parse(ordered_descriptions)
          end
        end
      end
    end
  end
end
