# Generated via
#  `rails generate hyrax:work Pdf`
module Hyrax
  class PdfForm < Hyrax::Forms::WorkForm
    self.model_class = ::Pdf
    self.terms += [:resource_type]
  end
end
