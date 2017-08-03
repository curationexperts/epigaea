require 'rails_helper'

RSpec.describe Tufts::ChangesetOverwriteStrategy do
  subject(:strategy) { described_class.new(model: model) }
  let(:model)        { FakeWork.new }

  it { is_expected.to have_attributes(model: model, changeset: be_empty) }

  shared_context 'with changes' do
    subject(:strategy) do
      described_class.new(model: model, changeset: changeset)
    end

    let(:changeset) do
      new_model = FakeWork.new(title: ['moomin', 'moominmama', 'snork'],
                               subject: ['too-ticky'])
      ActiveFedora::ChangeSet
        .new(new_model, new_model.resource, new_model.changed_attributes.keys)
    end
  end

  describe '#apply' do
    context 'with no changes' do
      it 'leaves the model unchanged' do
        expect { strategy.apply }.not_to change { model.resource.statements }
      end
    end

    context 'with changes' do
      include_context 'with changes'

      it 'applies the changes' do
        expect { strategy.apply }
          .to change { model.title.to_a }
          .to contain_exactly('moomin', 'moominmama', 'snork')
      end

      it 'updates changed attributes' do
        expect { strategy.apply }
          .to change { model.changed_attributes }
          .to include('title', 'subject')
      end
    end
  end
end
