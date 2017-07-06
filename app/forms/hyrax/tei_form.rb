# Generated via
#  `rails generate hyrax:work Tei`
module Hyrax
  class TeiForm < Hyrax::Forms::WorkForm
    self.model_class = ::Tei
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
