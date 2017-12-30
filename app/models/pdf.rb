class Pdf < Tufts::Curation::Pdf
  include ::Hyrax::WorkBehavior
  include ::Tufts::Draftable

  self.indexer = Tufts::Curation::Indexer
  self.human_readable_type = 'PDF'
end
