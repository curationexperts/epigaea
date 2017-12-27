# Override Hyrax CollectionPresenter with a local version that adds the EAD field
module Hyrax
  class TuftsCollectionPresenter < CollectionPresenter
    delegate :ead, to: :solr_document

    def self.terms
      Hyrax::CollectionPresenter.terms + [:ead]
    end
  end
end
