class GenericObject < Tufts::Curation::GenericObject
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Generic Object'
end
