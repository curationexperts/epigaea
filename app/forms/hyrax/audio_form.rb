# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    include Tufts::HasTranscriptForm
    self.model_class = ::Audio
    self.terms += Tufts::Terms.shared_terms
    self.terms += [:transcript_id]
    Tufts::Terms.remove_terms.each { |term| terms.delete(term) }
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

    def representative_id
      return if media_files.first[1].nil?
      media_files.first[1]
    end

    def thumbnail_id
      return if media_files.first[1].nil?
      media_files.first[1]
    end
  end
end
