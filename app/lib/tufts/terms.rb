module Tufts
  class Terms
    SHARED_TERMS = [:title, :displays_in, :abstract, :accrual_policy, :admin_start_date,
                    :alternative_title, :audience, :bibliographic_citation,
                    :contributor, :corporate_name, :createdby, :creator, :creator_department, :date_accepted,
                    :date_available, :date_copyrighted, :date_issued, :date_modified, :date_uploaded,
                    :description, :embargo_note, :end_date, :extent, :format_label, :funder, :genre, :has_format, :has_part,
                    :held_by, :identifier, :internal_note, :is_format_of, :is_replaced_by, :language, :legacy_pid,
                    :personal_name, :primary_date, :provenance, :publisher, :qr_note, :qr_status,
                    :rejection_reason, :replaces, :resource_type, :retention_period, :rights_holder, :rights_note,
                    :geographic_name, :steward, :subject, :table_of_contents, :temporal, :tufts_is_part_of, :tufts_license].freeze

    REMOVE_TERMS = [:license, :keyword, :based_near, :location].freeze
    def self.shared_terms
      SHARED_TERMS
    end

    def self.remove_terms
      REMOVE_TERMS
    end
  end
end
