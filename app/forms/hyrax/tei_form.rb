# Generated via
#  `rails generate hyrax:work Tei`
module Hyrax
  class TeiForm < Hyrax::Forms::WorkForm
    self.model_class = ::Tei
    self.terms += [:resource_type]
  end
end
