# Generated via
#  `rails generate hyrax:work Tei`
module Hyrax
  class TeiForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Tei
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
