class Collection < Tufts::Curation::Collection
  include ::Hyrax::CollectionBehavior
  self.indexer = Hyrax::CollectionWithBasicMetadataIndexer
end
