require 'rails_helper'

RSpec.describe TemplateUpdate, type: :model do
  subject(:batchable) { FactoryGirl.create(:template_update, batch: create(:batch)) }
  let(:notification) { instance_double(Hyrax::Workflow::BatchTemplateNotification) }

  it_behaves_like 'a batchable'

  describe '#behavior' do
    it 'is a writable attribute' do
      expect { batchable.behavior = described_class::PRESERVE }
        .to change { batchable.behavior }
        .to described_class::PRESERVE
    end
  end

  describe '#ids' do
    it 'is a writable attribute' do
      expect { batchable.ids = ['moomin1', 'moomin2'] }
        .to change { batchable.ids }
        .to contain_exactly('moomin1', 'moomin2')
    end
  end

  describe '#template_name' do
    it 'is a writable attribute' do
      expect { batchable.template_name = 'moomin' }
        .to change { batchable.template_name }
        .to 'moomin'
    end
  end

  describe '#enqueue!' do
    it 'sends a notification that the template has been applied' do
      allow(Hyrax::Workflow::BatchTemplateNotification).to receive(:new).and_return(notification)
      allow(notification).to receive(:call).and_return(nil)
      batchable.enqueue!
      expect(notification).to have_received(:call)
    end
  end
end
