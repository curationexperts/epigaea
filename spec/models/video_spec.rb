require 'rails_helper'

RSpec.describe Video do
  let(:work) { FactoryGirl.build(:video) }
  it_behaves_like 'a work with Tufts metadata attributes'

  it_behaves_like 'a draftable model' do
    subject(:model) { work }

    let(:change_map) do
      { title: ['Another title'], displays_in: ['dca'], subject: ['Testing'] }
    end
  end

  it { expect(described_class.human_readable_type).to eq 'Video' }
end
