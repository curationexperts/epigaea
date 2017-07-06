# Generated via
#  `rails generate hyrax:work Ead`
module Hyrax
  class EadForm < Hyrax::Forms::WorkForm
    self.model_class = ::Ead
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
