# Generated via
#  `rails generate hyrax:work Ead`
module Hyrax
  class EadForm < Hyrax::Forms::WorkForm
    self.model_class = ::Ead
    self.terms += Tufts::Terms.shared_terms
    self.required_fields = [:title, :displays_in]
    self.field_metadata_service = Tufts::MetadataService

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs
    end

    def title
      super.first || ""
    end
  end
end
