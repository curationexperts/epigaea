# Generated via
#  `rails generate hyrax:work VotingRecord`

module Hyrax
  class VotingRecordsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::VotingRecord

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::VotingRecordPresenter
    include Tufts::Drafts::Editable
  end
end
