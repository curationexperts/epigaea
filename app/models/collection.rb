class Collection < Tufts::Curation::Collection
  self.indexer = Hyrax::CollectionWithBasicMetadataIndexer
end
