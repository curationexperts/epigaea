require 'rails_helper'

RSpec.describe MetadataExport, type: :model do
  subject(:batchable) { FactoryGirl.create(:metadata_export) }

  it_behaves_like 'a batchable'

  it { is_expected.to have_attributes(batch_type: 'Export') }

  describe '#enqueue!' do
    subject(:batchable) { FactoryGirl.create(:metadata_export, batch: batch) }

    let(:batch)   { FactoryGirl.create(:batch, ids: ids) }
    let(:ids)     { objects.map(&:id) }
    let(:objects) { FactoryGirl.create_list(:pdf, 2) }

    it 'returns the same job id for all objects' do
      expect(batchable.enqueue!.values.uniq)
        .to contain_exactly(an_instance_of(String))
    end

    it 'enqeues one job for the full batch' do
      ActiveJob::Base.queue_adapter = :test

      expect { batchable.enqueue! }
        .to enqueue_job(MetadataExportJob)
        .once
    end
  end

  describe '#filename' do
    let(:filename) { 'moomin.xml' }

    it 'is an attribute' do
      expect { batchable.filename = filename }
        .to change { batchable.filename }
        .to filename
    end
  end
end
