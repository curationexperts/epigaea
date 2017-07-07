# Generated via
#  `rails generate hyrax:work Rcr`
module Hyrax
  class RcrForm < Hyrax::Forms::WorkForm
    self.model_class = ::Rcr
    self.terms += Tufts::Terms.shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
