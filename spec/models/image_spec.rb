# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  let(:image) { FactoryGirl.build(:image) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      image.displays_in = ['nowhere', 'trove']
      expect(image.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
