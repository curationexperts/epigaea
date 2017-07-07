# Generated via
#  `rails generate hyrax:work Video`
require 'rails_helper'

RSpec.describe Video do
  let(:work) { FactoryGirl.build(:video) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
