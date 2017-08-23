require 'rails_helper'

RSpec.describe Batch, type: :model do
  subject(:batch) { FactoryGirl.build(:batch) }

  it { is_expected.to have_attributes(creator: an_instance_of(User)) }

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
          .with(id)
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
