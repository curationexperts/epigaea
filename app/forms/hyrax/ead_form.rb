# Generated via
#  `rails generate hyrax:work Ead`
module Hyrax
  class EadForm < Hyrax::Forms::WorkForm
    self.model_class = ::Ead
    self.terms += [:resource_type]
  end
end
