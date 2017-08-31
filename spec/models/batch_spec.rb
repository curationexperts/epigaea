require 'rails_helper'

RSpec.describe Batch, type: :model, batch: true do
  subject(:batch) { FactoryGirl.build(:batch) }

  it { is_expected.to have_attributes(creator: an_instance_of(User)) }

  describe '#enqueue' do
    it 'calls enqueue on batchable' do
      allow(batch.batchable).to receive(:enqueue!).and_call_original

      batch.enqueue!
      expect(batch.batchable).to have_received(:enqueue!)
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#job_ids' do
    it { is_expected.to have_attributes(job_ids: be_empty) }

    context 'after it is enqueued' do
      let(:job_hash) { { 'obj1' => 'job1', 'obj2' => 'job2', 'obj3' => 'job3' } }

      before do
        allow(batch.batchable).to receive(:enqueue!).and_return(job_hash)
        batch.enqueue!
      end

      it 'has job ids' do
        expect(batch.job_ids).to contain_exactly(*job_hash.values)
      end

      context 'with no jobs returned' do
        let(:job_hash) { {} }

        it { is_expected.to have_attributes(job_ids: be_empty) }
      end
    end
  end

  describe '#ids' do
    context 'with no ids' do
      subject(:batch) { FactoryGirl.build(:batch, ids: nil) }
      it { is_expected.to have_attributes(ids: be_empty) }
    end

    it 'contains item ids' do
      expect(batch.ids).to contain_exactly('abc', '123')
    end
  end

  describe '#items' do
    let(:items) do
      batch.ids.each_with_object({}) { |id, h| h[id] = :"Item #{id}" }
    end

    before do
      items.each do |id, item|
        allow(described_class::Item)
          .to receive(:new)
          .with(id, batch.id)
          .and_return(item)
      end
    end

    it 'contains the items' do
      expect(batch.items).to contain_exactly(*items.values)
    end

    context 'with no ids' do
      subject(:batch) { FactoryGirl.build(:batch, ids: nil) }

      it 'is empty' do
        expect(batch.items.first).to be_nil
      end
    end
  end
end
