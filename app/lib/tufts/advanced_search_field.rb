# frozen_string_literal: true

###
# This class returns the Solr field name with the correct suffix. Not
# all fields in advanced search have a _tesim suffix.
module Tufts
  class AdvancedSearchField
    DTSI_FIELDS = ['date_modified', 'date_uploaded'].freeze

    # @param [String]
    # @return [String]
    def self.solr_suffix(field_name)
      if DTSI_FIELDS.include?(field_name)
        field_name + '_dtsi'
      else
        field_name + '_tesim'
      end
    end
  end
end
