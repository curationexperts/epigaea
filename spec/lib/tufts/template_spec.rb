require 'rails_helper'

RSpec.describe Tufts::Template do
  subject(:template) { described_class.new(name: name) }
  let(:name)         { 'test_template' }
  let(:model)        { model_class.new }
  let(:predicate)    { RDF::Vocab::DC.title }
  let(:model_class)  { FakeWork }

  after { described_class.all.each(&:delete) }

  it { is_expected.to have_attributes name: name }

  describe '.all' do
    it { expect(described_class.all.to_a).to be_empty }

    context 'with saved templates' do
      let(:templates) { [subject, described_class.new(name: 'other')] }

      before { templates.each(&:save) }

      it 'enumerates the templates' do
        expect(described_class.all.map(&:name))
          .to contain_exactly(name, 'other')
      end
    end
  end

  describe '.for' do
    it 'raises an error for wrong name' do
      expect { described_class.for(name: name) }
        .to raise_error "No Template found for #{name}."
    end

    context 'with saved templates' do
      let(:behavior) { :preserve }

      before { template.save }

      it 'returns a template with the correct name' do
        expect(described_class.for(name: name).name).to eq template.name
      end

      it 'builds a template with the given behavior' do
        expect(described_class.for(name: name, behavior: behavior).behavior)
          .to eq behavior
      end
    end
  end

  describe '.from_object' do
    before { model.title = ['moomin'] }

    it 'creates a template with the name' do
      expect(described_class.from_object(model, name: name))
        .to have_attributes name: name
    end

    it 'creates a template with the changes' do
      expect(described_class.from_object(model, name: name).changeset.changes)
        .to have_key predicate
    end
  end

  describe '#changeset' do
    it 'is empty by default' do
      expect(template.changeset).to be_empty
    end
  end

  describe '#exists?' do
    it { is_expected.not_to be_exists }
  end

  describe '#load' do
    it 'loads empty when unsaved' do
      expect { template.load }
        .not_to change { template.changeset.empty? }
        .from true
    end
  end

  describe '#save' do
    it 'exists after save' do
      expect { template.save }
        .to change { template.exists? }
        .from(false)
        .to true
    end
  end
end
