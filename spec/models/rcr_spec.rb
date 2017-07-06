# Generated via
#  `rails generate hyrax:work Rcr`
require 'rails_helper'

RSpec.describe Rcr do
  let(:rcr) { FactoryGirl.build(:rcr) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      rcr.displays_in = ['nowhere', 'trove']
      expect(rcr.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
