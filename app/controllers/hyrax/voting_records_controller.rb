# Generated via
#  `rails generate hyrax:work VotingRecord`

module Hyrax
  class VotingRecordsController < Tufts::WorksController
    self.curation_concern_type = ::VotingRecord
    self.show_presenter = Hyrax::VotingRecordPresenter
  end
end
