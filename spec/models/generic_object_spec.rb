# Generated via
#  `rails generate hyrax:work GenericObject`
require 'rails_helper'

RSpec.describe GenericObject do
  let(:generic_object) { FactoryGirl.build(:generic_object) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      generic_object.displays_in = ['nowhere', 'trove']
      expect(generic_object.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
