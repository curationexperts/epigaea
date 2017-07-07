# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Audio
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
