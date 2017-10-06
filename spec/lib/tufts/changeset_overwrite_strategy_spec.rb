require 'rails_helper'

RSpec.describe Tufts::ChangesetOverwriteStrategy do
  subject(:strategy) { described_class.new(model: model) }
  let(:model)        { FakeWork.new }

  it_behaves_like 'a ChangesetApplicationStrategy'

  describe '#apply' do
    context 'with changes' do
      include_context 'strategy with changes'

      it 'applies the changes' do
        expect { strategy.apply }
          .to change { model.subject.to_a }
          .to contain_exactly('too-ticky', 'snufkin')
      end

      it 'updates changed attributes' do
        expect { strategy.apply }
          .to change { model.changed_attributes }
          .to include('title', 'subject')
      end

      it 'uses only one first value for title' do
        expect { strategy.apply }
          .to change { model.title.to_a.count }
          .to eq 1
      end
    end
  end
end
