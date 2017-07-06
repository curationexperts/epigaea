# Generated via
#  `rails generate hyrax:work Tei`
require 'rails_helper'

RSpec.describe Tei do
  let(:tei) { FactoryGirl.build(:tei) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      tei.displays_in = ['nowhere', 'trove']
      expect(tei.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
