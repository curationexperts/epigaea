# Generated via
#  `rails generate hyrax:work GenericObject`

module Hyrax
  class GenericObjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::GenericObject

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericObjectPresenter
  end
end
