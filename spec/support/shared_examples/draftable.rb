##
# To use the shared examples, define a `subject(:model)` and a
# `let(:change_map). The `change_map` should be a map from attributes to
# valid values that the tests will ensure are properly applied through the
# draft interfaces.
RSpec.shared_examples 'a draftable model' do
  before do
    unless defined?(model)
      raise 'Define `model` with `let(:model)` before using the ' \
            'draftable model shared examples'
    end
    unless defined?(change_map)
      raise 'Define `change_map` with `let(:change_map)` before using the ' \
            'draftable model shared examples'
    end
    # The model has to be saved before drafts can be created
    model.save
  end

  after do
    model.delete_draft
    model.delete
  end

  define :have_changes do |expected|
    match do |actual|
      expected.each do |field, values|
        predicate = model.class.properties[field.to_s].predicate

        expect(actual.changeset.changes[predicate].each_object)
          .to contain_exactly(*Array(values))
      end
    end
  end

  define :have_unordered_attributes do |expected|
    match do |actual|
      attributes = Hash[expected.map do |k, v|
        v = contain_exactly(*v) if v.respond_to?(:each)
        [k, v]
      end]

      expect(actual).to have_attributes(attributes)
    end
  end

  shared_context 'with changes' do
    before { change_map.each { |k, v| model.send("#{k}=", v) } }
  end

  describe '#apply_draft' do
    context 'when empty' do
      it 'leaves the model unchanged' do
        expect { model.apply_draft }.not_to change { model.attributes }
      end

      it 'does not override model changes since draft save' do
        model.save_draft
        change_map.each { |k, v| model.send("#{k}=", v) }

        expect { model.apply_draft }.not_to change { model.attributes }
      end
    end

    context 'with changes' do
      include_context 'with changes'

      before do
        model.save_draft
        model.reload
      end

      it 'changes to the model attributes' do
        model.title = ['Another new title']
        model.apply_draft
        expect(model.title).not_to eq(['Another new title'])
      end

      it 'results in the correct changes' do
        model.apply_draft
        expect(model).to have_unordered_attributes(change_map)
      end
    end

    context 'when model has existing properties' do
      before do
        ##
        # split the changes into two sets, one we want to apply in draft,
        # and one which will exist before application. We'll expect all to be
        # present when we're done
        draft_changes = change_map.except(change_map.keys.first)
        prior_change  = change_map[change_map.keys.first]

        # build and save a draft
        draft_changes.each { |k, v| model.send("#{k}=", v) }
        model.save_draft

        # reload and update a property
        model.reload
        model.send("#{change_map.keys.first}=", prior_change)
      end

      it 'retains properties not changed in the draft' do
        model.apply_draft
        expect(model).to have_unordered_attributes(change_map)
      end

      it 'overwrites changes for properties in the draft' do
        optional "Sometimes fails on travis" if ENV['TRAVIS']
        model.send("#{change_map.keys.last}=", ['I SHOULD BE DELETED'])
        model.apply_draft
        expect(model).to have_unordered_attributes(change_map)
      end
    end
  end

  describe '#draft' do
    it 'has a model with the id' do
      expect(model.draft.id).to eq model.id
    end

    context 'with changes' do
      include_context 'with changes'

      it 'has changes' do
        expect(model.draft).to have_changes change_map
      end
    end

    context 'after saving the draft' do
      include_context 'with changes'

      before do
        model.save_draft
        model.reload
      end

      it 'loads the saved changes' do
        expect(model.draft).to have_changes change_map
      end
    end
  end

  describe '#draft_saved?' do
    it 'does not exist before save' do
      optional 'is optional on travis' if ENV['TRAVIS']
      expect(model).not_to be_draft_saved
    end
  end

  describe '#save_draft' do
    it 'marks the draft as saved' do
      expect { model.save_draft }
        .to change { model.draft_saved? }
        .from(false).to(true)
    end
  end
end
