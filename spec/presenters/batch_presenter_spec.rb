require 'rails_helper'

RSpec.describe BatchPresenter do
  subject(:presenter) { described_class.new(batch) }
  let(:batch)         { FactoryGirl.build(:batch) }

  it { is_expected.to delegate_method(:created_at).to(:object) }
  it { is_expected.to delegate_method(:id).to(:object) }
  it { is_expected.to delegate_method(:items).to(:object) }

  describe '#creator' do
    it 'is the creator #email' do
      expect(presenter.creator).to eq batch.creator.email
    end
  end

  describe '#count' do
    let(:ids) { ['abc', '123'] }

    before { batch.ids = ids }

    it 'is the number of ids/jobs' do
      expect(presenter.count).to eq ids.count.to_s
    end
  end

  describe '#review_status' do
    context 'with no items' do
      before { batch.ids = [] }

      it 'is complete' do
        expect(presenter.review_status)
          .to eq described_class::REVIEW_STATUSES[:complete]
      end
    end

    context 'with items' do
      let(:objects) { [create(:pdf), create(:pdf)] }

      before { batch.ids = objects.map(&:id) }

      it 'remains unreviewed when some items are reviewed' do
        expect { batch.items.first.object.mark_reviewed! }
          .not_to change { presenter.review_status }
          .from(described_class::REVIEW_STATUSES[:incomplete])
      end

      it 'becomes complete when all items are reviewed' do
        expect { batch.items.each { |i| i.object.mark_reviewed! } }
          .to change { presenter.review_status }
          .from(described_class::REVIEW_STATUSES[:incomplete])
          .to(described_class::REVIEW_STATUSES[:complete])
      end
    end
  end

  describe '#type' do
    let(:type) { 'Moomin Batch' }

    before do
      allow(batch.batchable).to receive(:batch_type).and_return(type)
    end

    it 'gives the type for the batchable' do
      expect(presenter.type).to eq type
    end

    context 'when batchable#batch_type is unimplemented' do
      before do
        allow(batch.batchable)
          .to receive(:respond_to?)
          .with(:batch_type)
          .and_return(false)
      end

      it 'gives a fallback string' do
        expect(presenter.type).to be_a String
      end
    end
  end
end
