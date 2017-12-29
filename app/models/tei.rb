class Tei < Tufts::Curation::Tei
  include ::Hyrax::WorkBehavior
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'TEI'
end
