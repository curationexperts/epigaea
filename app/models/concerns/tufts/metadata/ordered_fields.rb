module Tufts
  module Metadata
    module OrderedFields
      extend ActiveSupport::Concern

      included do
        # These properties are used to store the order for their corresponding (unordered) properties.
        # Don't set the value of these properties directly.  The values will be kept in sync by the setter method for the corresponding property.
        # For example, if you want to set the value for the 'description' property, you just use the setter as you normally would:
        # work.description = ['Desc 1', 'Desc 2']
        # and the corresponding 'ordered_descriptions'
        # property will automatically get set.

        # Stores the order for 'description' property
        property :ordered_descriptions, predicate: ::Tufts::Vocab::Tufts.ordered_descriptions, multiple: false do |index|
          index.as :symbol
        end

        # Stores the order for 'creator' property
        property :ordered_creators, predicate: ::Tufts::Vocab::Tufts.ordered_creators, multiple: false do |index|
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
          super
          self.ordered_descriptions = values.to_json
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

        # @param [Array] Ordered array of values
        # Overrides setter method to preserve order in a second property.
        def creator=(values)
          super
          self.ordered_creators = values.to_json
        end

        # @return [Array<String>]
        # Overrides getter method to return the creators in the correct order.
        def creator
          if ordered_creators.blank?
            super
          else
            JSON.parse(ordered_creators)
          end
        end
      end
    end
  end
end
