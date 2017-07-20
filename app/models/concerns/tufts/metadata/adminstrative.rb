module Tufts
  module Metadata
    module Adminstrative
      extend ActiveSupport::Concern
      included do
        property :displays_in, predicate: ::Tufts::Vocab::Terms.displays_in do |index|
          index.as :stored_searchable, :facetable
        end
        property :steward, predicate: ::Tufts::Vocab::Terms.steward, multiple: false do |index|
          index.as :stored_searchable
        end
        property :created_by, predicate: ::Tufts::Vocab::Terms.created_by, multiple: false do |index|
          index.as :stored_searchable
        end
        property :internal_note, predicate: ::Tufts::Vocab::Terms.internal_note, multiple: false do |index|
          index.as :stored_searchable
        end
        property :audience, predicate: ::RDF::Vocab::DC.audience, multiple: false do |index|
          index.as :stored_searchable
        end
        property :embargo_note, predicate: ::RDF::Vocab::PREMIS.TermOfRestriction, multiple: false do |index|
          index.as :stored_searchable
        end
        property :end_date, predicate: ::RDF::Vocab::PREMIS.hasEndDate, multiple: false do |index|
          index.as :stored_searchable
        end
        property :accrual_policy, predicate: ::RDF::Vocab::DC.accrualPolicy, multiple: false do |index|
          index.as :stored_searchable
        end
        property :rights_note, predicate: ::RDF::Vocab::DC11.rights, multiple: false do |index|
          index.as :stored_searchable
        end
        property :resource_type, predicate: ::RDF::Vocab::DC.type do |index|
          index.as :stored_searchable, :facetable
        end
      end
    end
  end
end
