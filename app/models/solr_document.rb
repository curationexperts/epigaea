# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior
  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  Tufts::Terms.shared_terms.each do |term|
    define_method(term) do
      if [:date_uploaded, :date_modified].include?(term)
        self[term.to_s + '_dtsi']
      else
        self[Solrizer.solr_name(term.to_s)]
      end
    end
  end

  # There was a Hyrax PR in progress to fix this: https://github.com/samvera/hyrax/pull/1384
  def itemtype
    result = super
    Logger.log(:warn, "Remove override in SolrDocumentBehavior#itemtype, it's no longer needed!")
    result
  rescue NameError
    types = resource_type || []
    Hyrax::ResourceTypesService.microdata_type(types.first)
  end

  def ead
    self[Solrizer.solr_name('ead')]
  end
end
