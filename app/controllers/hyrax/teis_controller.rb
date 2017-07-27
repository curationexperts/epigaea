# Generated via
#  `rails generate hyrax:work Tei`

module Hyrax
  class TeisController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Tei

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::TeiPresenter
    include Tufts::Drafts::Editable
  end
end
