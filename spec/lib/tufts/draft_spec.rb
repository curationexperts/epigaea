require 'rails_helper'
require 'tufts/draft'
require 'fileutils'

RSpec.describe Tufts::Draft do
  subject(:draft)   { described_class.new(model: model) }
  let(:model)       { model_class.new }
  let(:predicate)   { RDF::Vocab::DC.title }

  let(:model_class) do
    fake_draftable = Class.new(ActiveFedora::Base)
    fake_draftable.property(:title,   predicate: predicate)
    fake_draftable.property(:subject, predicate: RDF::Vocab::DC.subject)
    fake_draftable
  end

  before(:context) do
    unless File.directory?(described_class::STORAGE_DIR)
      FileUtils.mkdir_p(described_class::STORAGE_DIR)
    end
  end

  after { draft.delete }

  define :have_changes do |expected|
    match do |actual|
      expected.changes.each do |key, value|
        expect(actual.changes[key].to_a).to contain_exactly(*value.to_a)
      end
    end
  end

  shared_context 'with changes' do
    subject(:draft) { described_class.new(model: model, changeset: changeset) }

    let(:changeset) do
      new_model = model_class.new(title: ['moomin', 'moominmama', 'snork'],
                                  subject: ['too-ticky'])
      ActiveFedora::ChangeSet
        .new(new_model, new_model.resource, new_model.changed_attributes.keys)
    end
  end

  describe '.from_model' do
    subject(:draft) { described_class.from_model(model) }

    it 'generates a draft with the correct model' do
      expect(draft.model).to eql model
    end

    it 'has an empty changeset when model is unchanged' do
      expect(draft.changeset).to be_empty
    end

    context 'when model has changes' do
      before { model.title = ['moomin'] }

      it 'has a non-empty changeset' do
        expect(draft.changeset).not_to be_empty
      end

      it 'has the correct changes' do
        expect(draft.changeset.changes.keys).to contain_exactly predicate
      end

      it 'remains unchanged when the model changes again' do
        expect { model.title = ['Snorkmaiden'] }
          .not_to change { draft.changeset.changes }
      end
    end
  end

  describe '#apply' do
    context 'with no changes' do
      it 'leaves the model unchanged' do
        expect { draft.apply }.not_to change { model.resource.statements }
      end
    end

    context 'with changes' do
      include_context 'with changes'

      it 'applies the changes' do
        expect { draft.apply }
          .to change { model.title.to_a }
          .to contain_exactly('moomin', 'moominmama', 'snork')
      end

      it 'updates changed attributes' do
        expect { draft.apply }
          .to change { model.changed_attributes }
          .to include('title', 'subject')
      end
    end

    context 'when saved' do
      before { draft.save }

      it 'deletes the draft' do
        expect { draft.apply }
          .to change { draft.exists? }
          .from(true)
          .to(false)
      end
    end

    context 'with changes' do
      include_context 'with changes'

      it 'empties the changeset' do
        expect { draft.apply }
          .to change { draft.changeset.empty? }
          .from(false)
          .to(true)
      end
    end
  end

  describe '#changeset accessor' do
    it 'has an empty changeset on initalize' do
      expect(draft.changeset).to be_empty
    end
  end

  describe '#delete' do
    it 'does not change when not saved' do
      expect { draft.delete }
        .not_to change { draft.exists? }
        .from(false)
    end

    context 'when saved' do
      before { draft.save }

      it 'flips #exists? to false' do
        expect { draft.delete }
          .to change { draft.exists? }
          .from(true)
          .to(false)
      end
    end
  end

  describe '#id' do
    it 'gives the same value repeatably' do
      expect { draft.id }           # this actually calls #id 3 times,
        .not_to change { draft.id } # but it's cute so I'm keeping it.
    end
  end

  describe '#load' do
    it 'loads empty when unsaved' do
      expect { draft.load }
        .not_to change { draft.changeset.empty? }
        .from true
    end

    context 'with unsaved changes' do
      include_context 'with changes'

      it 'reloads empty' do
        expect { draft.load }
          .to change { draft.changeset.empty? }
          .from(false)
          .to(true)
      end
    end

    context 'with saved changes' do
      include_context 'with changes'

      before { draft.save }

      it 'retains the changes' do
        expect { draft.load }
          .not_to change { draft.changeset.changes }
      end

      it 'reloads saved changes' do
        saved_changes   = draft.changeset
        draft.changeset = Tufts::NullChangeSet.new

        expect { draft.load }
          .to change { draft.changeset }
          .to have_changes(saved_changes)
      end
    end
  end

  describe '#model accessor' do
    let(:new_model) { model_class.new }

    it 'sets the model' do
      expect { draft.model = new_model }
        .to change { draft.model }
        .from(model).to(new_model)
    end
  end

  describe '#save' do
    it 'exists after save' do
      expect { draft.save }
        .to change { draft.exists? }
        .from(false)
        .to(true)
    end
  end
end
