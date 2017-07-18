# Generated via
#  `rails generate hyrax:work Ead`
require 'rails_helper'

RSpec.describe Ead do
  changes = { title: ['A new title'], description: ['test'], subject: ['Testing'] }
  subject(:model) {  FactoryGirl.build(:ead) }
  let(:work) { model }
  let(:change_map) { changes }
  it_behaves_like 'a work with Tufts metadata attributes'
  it_behaves_like 'a draftable model'
end
