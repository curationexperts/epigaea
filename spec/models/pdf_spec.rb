require 'rails_helper'

RSpec.describe Pdf do
  let(:work) { FactoryGirl.build(:pdf) }
  it_behaves_like 'a work with Tufts metadata attributes'

  it_behaves_like 'a draftable model' do
    subject(:model) { work }

    let(:change_map) do
      { title: ['Another title'], displays_in: ['dca'], subject: ['Testing'] }
    end
  end

  it { expect(described_class.human_readable_type).to eq 'PDF' }

  context 'when it is in a batch' do
    let!(:batch) { FactoryGirl.create(:batch, ids: [work.id]) }

    it 'indexes the batches' do
      expect(work.to_solr['batch_tesim']).to contain_exactly(batch.id)
    end
  end
end
