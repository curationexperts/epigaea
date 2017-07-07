# Generated via
#  `rails generate hyrax:work VotingRecord`
module Hyrax
  class VotingRecordForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::VotingRecord
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
