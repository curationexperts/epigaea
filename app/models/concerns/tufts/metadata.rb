module Tufts
  module Metadata
    extend ActiveSupport::Concern
    included do
      property :displays_in, predicate: ::Tufts::Vocab::Terms.displays_in do |index|
        index.as :stored_searchable, :facetable
      end
      property :geographic_name, predicate: ::RDF::Vocab::DC.spatial do |index|
        index.as :stored_searchable
      end
      property :held_by, predicate: ::RDF::Vocab::Bibframe.heldBy do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
