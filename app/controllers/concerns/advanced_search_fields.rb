module AdvancedSearchFields
  extend ActiveSupport::Concern

  included do
    configure_blacklight do |config|
      # Attributes to include in the advanced search form
      adv_search_attrs = Tufts::Terms.shared_terms
      already_included_attrs = [:contributor, :date_created, :title, :creator, :subject, :batch,
                                :description, :displays_in, :geographic_name, :held_by, :identifier,
                                :language, :publisher, :resource_type]
      adv_search_attrs -= already_included_attrs

      adv_search_attrs.each do |attr|
        field_name = attr.to_s.underscore
        full_field_name = Tufts::AdvancedSearchField.solr_suffix(field_name)
        config.add_search_field(field_name) do |field|
          field.include_in_simple_select = false
          field.solr_local_parameters = { qf: full_field_name }
          # using :format_attr for :format because :format refers to the response
          # format in rails controllers
          if attr == :format
            field.field = "format_attr"
            field.label = "Format test"
          end
        end
      end
    end
  end # included
end
