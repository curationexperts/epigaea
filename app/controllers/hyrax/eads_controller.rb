# Generated via
#  `rails generate hyrax:work Ead`

module Hyrax
  class EadsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Ead

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::EadPresenter
  end
end
