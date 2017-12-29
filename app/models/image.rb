class Image < Tufts::Curation::Image
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Image'
end
