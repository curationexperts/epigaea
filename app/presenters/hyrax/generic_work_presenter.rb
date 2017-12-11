module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    Tufts::Terms.shared_terms.each { |term| delegate term, to: :solr_document }

    def date_modified
      return if solr_document[:date_modified_dtsi].nil?
      DateTime.parse(solr_document[:date_modified_dtsi]).in_time_zone.strftime('%F')
    end

    def date_uploaded
      return if solr_document[:date_uploaded_dtsi].nil?
      DateTime.parse(solr_document[:date_uploaded_dtsi]).in_time_zone.strftime('%F')
    end

    ##
    # @return [Boolean] true; all works in the app are templatable.
    def work_templatable?
      true
    end
  end
end
