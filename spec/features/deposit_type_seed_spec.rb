require 'rails_helper'
require 'import_export/deposit_type_importer'

RSpec.feature 'DepositType seed' do
  before :all do
    Rails.application.load_seed
  end

  let(:deposit_types) { CSV.read('./config/deposit_type_seed.csv', headers: true) }
  let(:known_display_name) { deposit_types.first.field("display_name") }

  it 'gets loaded' do
    expect(DepositType.count).to be > 0
  end

  it "populates expected data" do
    matching_records = DepositType.where(display_name: known_display_name)
    expect(matching_records).not_to be_empty
  end
end
