module Tufts
  module Metadata
    module Adminstrative
      extend ActiveSupport::Concern

      REVIEWED_STRING = 'Batch Reviewed'.freeze

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
        property :retention_period, predicate: ::Tufts::Vocab::Terms.retention_period do |index|
          index.as :stored_searchable
        end
        property :admin_start_date, predicate: ::Tufts::Vocab::Terms.start_date do |index|
          index.as :stored_searchable
        end
        property :qr_status, predicate: ::Tufts::Vocab::Terms.qr_status do |index|
          index.as :stored_searchable
        end
        property :rejection_reason, predicate: ::Tufts::Vocab::Terms.rejection_reason do |index|
          index.as :stored_searchable
        end
        property :qr_note, predicate: ::Tufts::Vocab::Terms.qr_note do |index|
          index.as :stored_searchable
        end
        property :creator_department, predicate: ::Tufts::Vocab::Terms.creator_department do |index|
          index.as :stored_searchable
        end
        property :legacy_pid, predicate: ::Tufts::Vocab::Terms.legacy_pid, multiple: false do |index|
          index.as :stored_searchable
        end
        property :createdby, predicate: ::Tufts::Vocab::Terms.createdby, multiple: false do |index|
          index.as :stored_searchable, :facetable
        end
      end

      def mark_reviewed
        self.qr_status = [REVIEWED_STRING]
      end

      def mark_reviewed!
        mark_reviewed
        save
      end

      def reviewed?
        qr_status.include?(REVIEWED_STRING)
      end
    end
  end
end
