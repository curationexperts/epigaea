# Generated via
#  `rails generate hyrax:work GenericObject`
module Hyrax
  class GenericObjectForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::GenericObject
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
