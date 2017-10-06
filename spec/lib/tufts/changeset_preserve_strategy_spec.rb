require 'rails_helper'

RSpec.describe Tufts::ChangesetPreserveStrategy do
  subject(:strategy) { described_class.new(model: model) }
  let(:model)        { FakeWork.new }

  it_behaves_like 'a ChangesetApplicationStrategy'

  describe '#apply' do
    context 'with changes' do
      include_context 'strategy with changes'

      it 'applies the changes to empty field' do
        expect { strategy.apply }
          .to change { model.subject.to_a }
          .to contain_exactly('too-ticky', 'snufkin')
      end

      it 'updates changed attributes' do
        expect { strategy.apply }
          .to change { model.changed_attributes }
          .to include('title', 'subject')
      end

      it 'merges existing values' do
        model.subject = ['hobgoblin']

        expect { strategy.apply }
          .to change { model.subject.to_a }
          .to contain_exactly('hobgoblin', 'too-ticky', 'snufkin')
      end

      it 'leaves existing values unchanged for fields not in the changeset' do
        model.relation = ['snufkin']

        expect { strategy.apply }
          .not_to change { model.relation.to_a }
          .from contain_exactly('snufkin')
      end

      it 'applies the changes to empty single-valued field' do
        expect { strategy.apply }
          .to change { model.single_value }
          .to eq 'moomin'
      end

      it 'retains the value in an existing single-valued field' do
        model.single_value = 'snufkin'

        expect { strategy.apply }
          .not_to change { model.single_value }
          .from 'snufkin'
      end

      it 'applies one value to empty title field' do
        expect { strategy.apply }
          .to change { model.title.to_a.count }
          .to eq 1
      end

      it 'retains the value in an existing title field' do
        model.title = ['snufkin']

        expect { strategy.apply }
          .not_to change { model.title.to_a }
          .from a_collection_containing_exactly('snufkin')
      end
    end
  end
end
