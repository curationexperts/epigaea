require 'rails_helper'

RSpec.describe Tufts::Template do
  subject(:template) { described_class.new(name: name) }
  let(:name)         { 'test_template' }

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
      before { template.save }

      it 'raises an error for wrong name' do
        expect(described_class.for(name: name).name).to eq template.name
      end
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

  describe '#save' do
    it 'exists after save' do
      expect { template.save }
        .to change { template.exists? }
        .from(false)
        .to true
    end
  end
end
