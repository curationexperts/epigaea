module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    Tufts::Terms.shared_terms.each { |term| delegate term, to: :solr_document }

    ##
    # @return [Boolean] true; all works in the app are templatable.
    def work_templatable?
      true
    end
  end
end
