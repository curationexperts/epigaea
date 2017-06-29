# Generated via
#  `rails generate hyrax:work Rcr`
module Hyrax
  class RcrForm < Hyrax::Forms::WorkForm
    self.model_class = ::Rcr
    self.terms += [:resource_type]
  end
end
