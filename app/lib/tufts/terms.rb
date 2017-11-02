module Tufts
  class Terms
    SHARED_TERMS = [:displays_in, :geographic_name,
                    :held_by, :alternative_title,
                    :abstract, :table_of_contents, :primary_date, :date_accepted,
                    :date_available, :date_copyrighted, :date_issued, :steward,
                    :internal_note, :audience, :embargo_note, :end_date, :accrual_policy,
                    :rights_note, :rights_holder, :format_label, :replaces, :is_replaced_by,
                    :has_format, :is_format_of, :bibliographic_citation, :has_part, :tufts_license,
                    :retention_period, :admin_start_date, :qr_status, :rejection_reason,
                    :qr_note, :creator_department, :legacy_pid, :temporal, :extent,
                    :personal_name, :corporate_name, :genre, :provenance, :funder, :createdby,
                    :tufts_is_part_of, :resource_type].sort.freeze

    REMOVE_TERMS = [:license, :keyword, :based_near].freeze
    DEFAULT_TERMS = [:subject, :creator, :contributor, :publisher, :language, :date_uploaded,
                     :date_modified, :date_created, :identifier].freeze
    ALL_TERMS = (SHARED_TERMS + DEFAULT_TERMS).sort.freeze
    def self.shared_terms
      SHARED_TERMS
    end

    def self.remove_terms
      REMOVE_TERMS
    end

    def self.all_terms
      ALL_TERMS
    end
  end
end
