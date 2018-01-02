class VotingRecord < Tufts::Curation::TuftsModel
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Voting Record'
end
