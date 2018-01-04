require 'rails_helper'

RSpec.describe GenericObject do
  let(:work) { FactoryGirl.build(:generic_object) }
  it_behaves_like 'a work with Tufts metadata attributes'

  it_behaves_like 'a draftable model' do
    subject(:model) { work }

    let(:change_map) do
      { title: ['Another title'], displays_in: ['dca'], subject: ['Testing'] }
    end
  end

  it { expect(described_class.human_readable_type).to eq 'Generic Object' }
end
