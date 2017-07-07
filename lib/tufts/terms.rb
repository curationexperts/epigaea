module Tufts
  class Terms
    SHARED_TERMS = [:displays_in, :geographic_name, :held_by, :alternative_title,
                    :abstract, :table_of_contents, :primary_date, :date_accepted,
                    :date_available, :date_copyrighted, :date_issued, :steward, :created_by,
                    :internal_note, :audience, :embargo_note, :end_date, :accrual_policy, :license].freeze
    def self.shared_terms
      SHARED_TERMS
    end
  end
end
