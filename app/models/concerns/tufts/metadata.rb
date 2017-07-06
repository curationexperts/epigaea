module Tufts
  module Metadata
    extend ActiveSupport::Concern
    included do
      property :displays_in, predicate: ::Tufts::Vocab::Terms.displays_in
    end
  end
end
