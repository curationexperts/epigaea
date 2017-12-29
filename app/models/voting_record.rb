class VotingRecord < Tufts::Curation::TuftsModel
  include ::Hyrax::WorkBehavior
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Voting Record'
end
