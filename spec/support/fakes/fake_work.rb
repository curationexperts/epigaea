class FakeWork < ActiveFedora::Base
  PREDICATES = [::RDF::Vocab::DC.title,
                ::RDF::Vocab::DC.subject,
                ::RDF::Vocab::DC.relation,
                ::RDF::Vocab::DC.format].freeze

  property :title,        predicate: PREDICATES[0]
  property :subject,      predicate: PREDICATES[1]
  property :relation,     predicate: PREDICATES[2]
  property :single_value, predicate: PREDICATES[3], multiple: false
end
