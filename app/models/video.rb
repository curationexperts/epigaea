class Video < Tufts::Curation::Video
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'Video'
end
