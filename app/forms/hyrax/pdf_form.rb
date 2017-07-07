# Generated via
#  `rails generate hyrax:work Pdf`
module Hyrax
  class PdfForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Pdf
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
