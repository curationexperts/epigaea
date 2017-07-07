# Generated via
#  `rails generate hyrax:work GenericObject`
require 'rails_helper'

RSpec.describe GenericObject do
  let(:work) { FactoryGirl.build(:generic_object) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
