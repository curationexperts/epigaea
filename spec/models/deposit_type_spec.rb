require 'rails_helper'

describe DepositType do
  let(:deposit_type) { FactoryGirl.create(:deposit_type) }

  it 'requires a display_name' do
    expect(FactoryGirl.build(:deposit_type, display_name: nil)).not_to be_valid
  end

  it 'requires a license_name' do
    expect(FactoryGirl.build(:deposit_type, license_name: nil)).not_to be_valid
  end

  it 'requires a deposit_view' do
    expect(FactoryGirl.build(:deposit_type, deposit_view: nil)).not_to be_valid
  end

  it 'has a deposit_agreement' do
    expect(deposit_type.deposit_agreement).to eq 'legal jargon here...'
  end

  it 'must have unique display names' do
    deposit_type # build the deposit type
    dup_type =
      FactoryGirl.build(:deposit_type, display_name: deposit_type.display_name)

    expect(dup_type).not_to be_valid
  end

  it 'must have a deposit_view that points to a vaild partial' do
    invalid_partial_type =
      FactoryGirl.build(:deposit_type, deposit_view: 'invalid_view_partial')

    expect(invalid_partial_type).not_to be_valid
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'sanitizes deposit_agreement input' do
    bad_text = "<script> JS Attack! </script> <a href='/license'>Legitimate Link</a>"
    dt = FactoryGirl.create(:deposit_type, deposit_agreement: bad_text)

    expect(dt.deposit_agreement.match(/script/)).to be_nil
    expect(dt.deposit_agreement.match(/href="\/license"/)).not_to be_nil
    expect(dt.deposit_agreement.match(/<\/a>/)).not_to be_nil
  end
end
