require 'rails_helper'
require 'tufts/draftable'

RSpec.describe Tufts::Draftable do
  subject(:model) { model_class.create }

  let(:model_class) do
    klass = Class.new(ActiveFedora::Base)
    klass.include described_class
    klass.property :subject,    predicate: RDF::URI('http://example.com/s')
    klass.property :characters, predicate: RDF::URI('http://example.com/c')
    klass.property :title,
                   predicate: RDF::URI('http://example.com/t'),
                   multiple: false
    klass
  end

  let(:change_map) do
    { title:      'Comet in Moominland',
      subject:    ['Moomins', 'Snorks'],
      characters: ['Moomin', 'Moominpapa', 'Snorkmaiden', 'Little My'] }
  end

  it_behaves_like 'a draftable model'
end
