# Generated via
#  `rails generate hyrax:work Pdf`

module Hyrax
  class PdfsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Pdf

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PdfPresenter
  end
end
