# Generated via
#  `rails generate hyrax:work Audio`

module Hyrax
  class AudiosController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Audio

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::AudioPresenter
    include Tufts::Drafts::Editable
  end
end
