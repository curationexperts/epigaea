# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  let(:work) { FactoryGirl.build(:image) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
