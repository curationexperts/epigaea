require 'rails_helper'

RSpec.describe Hyrax::TemplateForm do
  subject(:form)   { described_class.new(model, ability, controller) }
  let(:ability)    { nil }
  let(:controller) { nil }
  let(:model)      { FactoryGirl.create(:pdf) }

  shared_context 'with a template' do
    subject(:form) do
      described_class.new(model, ability, controller, template: template)
    end

    let(:template) { FactoryGirl.build(:template) }
  end

  describe '.terms' do
    it 'has template_name as its first term' do
      expect(described_class.terms.first).to eq :template_name
    end
  end

  describe '.required_fields' do
    it 'has no required fields' do
      expect(described_class.required_fields).to be_empty
    end
  end

  describe '#template' do
    let(:new_template) { :new_template }

    it 'is a setter that defaults to a template' do
      expect { form.template = new_template }
        .to change { form.template }
        .from(an_instance_of(Tufts::Template))
        .to new_template
    end
  end

  describe '#template_name' do
    it 'has a non-empty default name' do
      expect(form.template_name).not_to be_empty
    end

    context 'with a template' do
      include_context 'with a template'

      it 'matches the name of the given template' do
        expect(form.template_name).to eq template.name
      end
    end
  end
end
