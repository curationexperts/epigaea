class Rcr < Tufts::Curation::Rcr
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'RCR'
end
