require 'rails_helper'

RSpec.describe Ead do
  subject(:model) {  FactoryGirl.build(:ead) }
  let(:work) { model }

  it_behaves_like 'a work with Tufts metadata attributes'

  it_behaves_like 'a draftable model' do
    let(:change_map) do
      { title: ['Another title'], displays_in: ['dca'], subject: ['Testing'] }
    end
  end

  it { expect(described_class.human_readable_type).to eq 'EAD' }
end
