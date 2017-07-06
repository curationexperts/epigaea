# Generated via
#  `rails generate hyrax:work Video`
require 'rails_helper'

RSpec.describe Video do
  let(:video) { FactoryGirl.build(:video) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      video.displays_in = ['nowhere', 'trove']
      expect(video.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
