# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    include Tufts::HasTranscriptForm
    self.model_class = ::Audio
    terms.delete(:license)
    self.terms += Tufts::Terms.shared_terms
    self.terms += [:transcript_id]
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
