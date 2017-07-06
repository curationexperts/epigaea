# Generated via
#  `rails generate hyrax:work Pdf`
module Hyrax
  class PdfForm < Hyrax::Forms::WorkForm
    self.model_class = ::Pdf
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
