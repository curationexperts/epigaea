# Generated via
#  `rails generate hyrax:work GenericObject`
module Hyrax
  class GenericObjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::GenericObject
    self.terms += Tufts::Terms.shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
