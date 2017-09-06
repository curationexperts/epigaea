require 'rails_helper'

RSpec.describe BatchTask, type: :model do
  subject(:batchable) { FactoryGirl.build(:batch_task) }

  it_behaves_like 'a batchable'

  it { is_expected.to have_attributes batch_type: 'Publish' }

  it 'validates batch types' do
    expect(described_class.new(batch_type: 'NONSENSE')).not_to be_valid
  end

  describe '#enqueue!' do
    let(:batch) { FactoryGirl.create(:batch, ids: [id]) }
    let(:id)    { 'FAKE_ID' }

    before { batchable.batch = batch }

    it 'enqueues the correct job type' do
      ActiveJob::Base.queue_adapter = :test

      expect { batchable.enqueue! }
        .to enqueue_job(PublishJob)
        .with(id)
        .on_queue('batch')
    end
  end

  describe '.job_for' do
    it 'gives a batchable job' do
      expect(described_class.job_for(batchable.batch_type)).to be < BatchableJob
    end
  end

  describe '#ids' do
    let(:batch) { FactoryGirl.create(:batch) }

    it 'is empty' do
      expect(batchable.ids).to be_empty
    end

    context 'with a batch' do
      let(:batch) { FactoryGirl.create(:batch) }

      before { batchable.batch = batch }

      it 'has the ids from the batch' do
        expect(batchable.ids).to contain_exactly(*batch.ids)
      end
    end
  end
end
