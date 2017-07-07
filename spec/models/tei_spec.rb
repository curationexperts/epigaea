# Generated via
#  `rails generate hyrax:work Tei`
require 'rails_helper'

RSpec.describe Tei do
  let(:work) { FactoryGirl.build(:tei) }
  it_behaves_like 'a work with Tufts metadata attributes'
end
