module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    delegate :displays_in, to: :solr_document
    delegate :geographic_name, to: :solr_document
  end
end
