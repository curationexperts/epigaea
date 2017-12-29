class Audio < Tufts::Curation::Audio
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Audio'
end
