# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'

RSpec.describe Audio do
  let(:audio) { FactoryGirl.build(:audio) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      audio.displays_in = ['nowhere', 'trove']
      expect(audio.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
