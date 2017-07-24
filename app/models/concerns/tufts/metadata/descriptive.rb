module Tufts
  module Metadata
    module Descriptive
      extend ActiveSupport::Concern
      included do
        property :geographic_name, predicate: ::RDF::Vocab::DC.spatial do |index|
          index.as :stored_searchable
        end
        property :held_by, predicate: ::RDF::Vocab::Bibframe.heldBy do |index|
          index.as :stored_searchable, :facetable
        end
        property :alternative_title, predicate: ::RDF::Vocab::DC.alternative do |index|
          index.as :stored_searchable
        end
        property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
          index.as :stored_searchable
        end
        property :table_of_contents, predicate: ::RDF::Vocab::DC.tableOfContents do |index|
          index.as :stored_searchable
        end
        property :primary_date, predicate: ::RDF::Vocab::DC11.date do |index|
          index.as :stored_searchable
        end
        property :date_accepted, predicate: ::RDF::Vocab::DC.dateAccepted do |index|
          index.as :stored_searchable
        end
        property :date_available, predicate: ::RDF::Vocab::DC.available do |index|
          index.as :stored_searchable
        end
        property :date_copyrighted, predicate: ::RDF::Vocab::DC.dateCopyrighted do |index|
          index.as :stored_searchable
        end
        property :date_issued, predicate: ::RDF::Vocab::EBUCore.dateIssued do |index|
          index.as :stored_searchable
        end
        property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation do |index|
          index.as :stored_searchable
        end
      end
    end
  end
end
