# Generated via
#  `rails generate hyrax:work Rcr`
require 'rails_helper'

RSpec.describe Rcr do
  let(:work) { FactoryGirl.build(:rcr) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
