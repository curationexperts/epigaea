# Generated via
#  `rails generate hyrax:work VotingRecord`
module Hyrax
  class VotingRecordForm < Hyrax::Forms::WorkForm
    self.model_class = ::VotingRecord
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
