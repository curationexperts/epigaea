# Generated via
#  `rails generate hyrax:work Rcr`
module Hyrax
  class RcrForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Rcr
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
