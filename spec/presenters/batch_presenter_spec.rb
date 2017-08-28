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
end
