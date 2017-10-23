require 'rails_helper'

RSpec.describe MetadataImportJob, type: :job do
  subject(:job) { described_class }

  it_behaves_like 'an ActiveJob job'

  describe '#perform' do
    let(:id)      { import.ids.first }
    let(:import)  { FactoryGirl.create(:metadata_import) }
    let!(:object) { FactoryGirl.create(:populated_pdf, id: id, title: old) }
    let(:old)     { ['Old Title Data'] }

    it 'updates the metadata' do
      expect { job.perform_now(import, id) }
        .to change { object.reload.title }
        .from(old)
        .to contain_exactly('I Married a Electric Ninjas')
    end
  end
end
