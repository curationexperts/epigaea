# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    self.model_class = ::Audio
    self.terms += Tufts::Terms.shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
