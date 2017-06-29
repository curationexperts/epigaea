# Generated via
#  `rails generate hyrax:work GenericObject`
module Hyrax
  class GenericObjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::GenericObject
    self.terms += [:resource_type]
  end
end
