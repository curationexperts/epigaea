module Tufts
  module Forms
    extend ActiveSupport::Concern
    included do
      def self.shared_terms
        [:displays_in, :geographic_name]
      end
    end
  end
end
