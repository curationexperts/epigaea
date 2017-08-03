require 'rails_helper'

RSpec.describe TemplateUpdate, type: :model do
  subject(:update) { FactoryGirl.create(:template_update) }

  describe '#behavior' do
    it 'is a writable attribute' do
      expect { update.behavior = described_class::PRESERVE }
        .to change { update.behavior }
        .to described_class::PRESERVE
    end
  end

  describe '#ids' do
    it 'is a writable attribute' do
      expect { update.ids = ['moomin1', 'moomin2'] }
        .to change { update.ids }
        .to contain_exactly('moomin1', 'moomin2')
    end
  end

  describe '#template_name' do
    it 'is a writable attribute' do
      expect { update.template_name = 'moomin' }
        .to change { update.template_name }
        .to 'moomin'
    end
  end
end
