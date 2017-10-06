# rubocop:disable Lint/HandleExceptions
RSpec.shared_examples 'a ChangesetApplicationStrategy' do
  subject(:strategy) { described_class.new(model: model) }
  let(:model)        { FakeWork.new }

  it { is_expected.to have_attributes(model: model, changeset: be_empty) }

  describe '#apply' do
    context 'with no changes' do
      it 'leaves the model unchanged' do
        begin
          expect { strategy.apply }.not_to change { model.resource.statements }
        rescue NotImplementedError; end
      end
    end
  end
end

RSpec.shared_context 'strategy with changes' do
  subject(:strategy) do
    described_class.new(model: model, changeset: changeset)
  end

  let(:changeset) do
    new_model = FakeWork.new(title:        ['moomin', 'moominmama', 'snork'],
                             subject:      ['too-ticky', 'snufkin'],
                             single_value: 'moomin')
    ActiveFedora::ChangeSet
      .new(new_model, new_model.resource, new_model.changed_attributes.keys)
  end
end
