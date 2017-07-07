# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'

RSpec.describe Audio do
  let(:work) { FactoryGirl.build(:audio) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
