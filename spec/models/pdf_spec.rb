# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
RSpec.describe Pdf do
  let(:work) { FactoryGirl.build(:pdf) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
