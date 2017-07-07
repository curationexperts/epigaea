# Generated via
#  `rails generate hyrax:work Ead`
require 'rails_helper'

RSpec.describe Ead do
  let(:work) { FactoryGirl.build(:ead) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
