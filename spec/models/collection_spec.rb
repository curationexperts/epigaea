require 'rails_helper'

RSpec.describe Collection, type: :model do
  subject(:collection) { FactoryGirl.build(:collection, ead: ead_id) }
  let(:ead_id) { ["ead123"] }

  it_behaves_like 'a record with ordered fields' do
    let(:work) { collection }
  end

  it "can have an associated EAD" do
    expect(collection.ead).to eq ead_id
  end
end
