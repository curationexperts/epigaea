module Tufts
  module Forms
    extend ActiveSupport::Concern
    included do
      def self.shared_terms
        [:displays_in, :geographic_name, :held_by]
      end
    end
  end
end
