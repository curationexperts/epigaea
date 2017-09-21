module Tufts::HasTranscription
  extend ActiveSupport::Concern

  included do
    belongs_to :transcript,
               predicate: ::RDF::Vocab::EBUCore.description,
               class_name: 'ActiveFedora::Base'
  end
end
