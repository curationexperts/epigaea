class Ead < Tufts::Curation::Ead
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'EAD'
end
