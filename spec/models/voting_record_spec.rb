# Generated via
#  `rails generate hyrax:work VotingRecord`
require 'rails_helper'

RSpec.describe VotingRecord do
  let(:voting_record) { FactoryGirl.build(:voting_record) }
  context 'displays_in' do
    it 'has Tufts displays_in metadata' do
      voting_record.displays_in = ['nowhere', 'trove']
      expect(voting_record.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
