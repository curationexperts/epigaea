require 'rails_helper'

RSpec.describe Collection do
  let(:collection) { FactoryGirl.build(:collection) }

  # The shared examples expect it to be called 'work':
  let(:work) { collection }
  it_behaves_like 'a record with ordered fields'
end
