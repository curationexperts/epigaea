class FakeWork < ActiveFedora::Base
  PREDICATES = [::RDF::Vocab::DC.title,
                ::RDF::Vocab::DC.subject].freeze

  property :title,   predicate: PREDICATES[0]
  property :subject, predicate: PREDICATES[1]
end
