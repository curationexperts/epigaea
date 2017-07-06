# Generated via
#  `rails generate hyrax:work Ead`
require 'rails_helper'

RSpec.describe Ead do
  let(:ead) { FactoryGirl.build(:ead) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      ead.displays_in = ['nowhere', 'trove']
      expect(ead.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
