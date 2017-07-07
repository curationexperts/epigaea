module Tufts
  module Metadata
    extend ActiveSupport::Concern
    included do
      property :displays_in, predicate: ::Tufts::Vocab::Terms.displays_in do |index|
        index.as :stored_searchable
      end
      property :geographic_name, predicate: ::RDF::Vocab::DC.spatial do |index|
        index.as :stored_searchable
      end
    end
  end
end
