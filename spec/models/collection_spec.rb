require 'rails_helper'

RSpec.describe Collection, type: :model do
  subject(:collection) { FactoryGirl.build(:collection, ead: ead_id) }
  let(:ead_id) { ["ead123"] }
  # The shared examples expect it to be called 'work':
  let(:work) { collection }
  it_behaves_like 'a record with ordered fields'

  it "can have an associated EAD" do
    expect(collection.ead).to eq ead_id
  end
end
