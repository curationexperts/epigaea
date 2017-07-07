# Generated via
#  `rails generate hyrax:work VotingRecord`
require 'rails_helper'

RSpec.describe VotingRecord do
  let(:work) { FactoryGirl.build(:voting_record) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
