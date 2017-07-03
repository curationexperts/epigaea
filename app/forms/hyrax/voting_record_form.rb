# Generated via
#  `rails generate hyrax:work VotingRecord`
module Hyrax
  class VotingRecordForm < Hyrax::Forms::WorkForm
    self.model_class = ::VotingRecord
    self.terms += [:resource_type]
  end
end
