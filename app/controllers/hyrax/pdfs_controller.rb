# Generated via
#  `rails generate hyrax:work Pdf`

module Hyrax
  class PdfsController < Tufts::WorksController
    self.curation_concern_type = ::Pdf
    self.show_presenter = Hyrax::PdfPresenter
  end
end
