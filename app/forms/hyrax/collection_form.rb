# Override Hyrax::Forms::CollectionForm so we can add an EAD field
module Hyrax
  class CollectionForm < Hyrax::Forms::CollectionForm
    self.terms += [:ead]

    # Terms that appear above the accordion
    def primary_terms
      [:title, :ead]
    end
  end
end
