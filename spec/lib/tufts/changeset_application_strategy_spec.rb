require 'rails_helper'

RSpec.describe Tufts::ChangesetApplicationStrategy do
  let(:changeset) { Tufts::NullChangeSet.new }
  let(:model)     { FakeWork.new }

  it_behaves_like 'a ChangesetApplicationStrategy'

  describe '.for' do
    it 'returns an instance of itself if' do
      expect(described_class.for(:overwrite, model: model))
        .to be_a described_class
    end

    it 'returns instances of subclasses' do
      expect(described_class.for(:overwrite, model: model))
        .to be_a Tufts::ChangesetOverwriteStrategy
    end

    it 'sets the model' do
      expect(described_class.for(:overwrite, model: model).model)
        .to eql model
    end

    it 'sets the changeset' do
      strategy = described_class.for(:overwrite,
                                     model:     model,
                                     changeset: changeset)
      expect(strategy.changeset).to eql changeset
    end
  end
end
