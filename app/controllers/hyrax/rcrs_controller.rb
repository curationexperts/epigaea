# Generated via
#  `rails generate hyrax:work Rcr`

module Hyrax
  class RcrsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Rcr

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::RcrPresenter
  end
end
