# Generated via
#  `rails generate hyrax:work GenericObject`
module Hyrax
  class GenericObjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::GenericObject
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
