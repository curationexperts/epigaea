require 'rails_helper'

RSpec.describe UnpublishJob, :workflow, type: :job do
  subject(:job) { described_class }
  let(:pdf)     { FactoryGirl.create(:pdf) }

  before { ActiveJob::Base.queue_adapter = :test }

  describe '#perform_later' do
    it 'enqueues the job' do
      expect { job.perform_later(pdf.id) }
        .to enqueue_job(described_class)
        .with(pdf.id)
        .on_queue('batch')
    end
  end

  context "workflow transition" do
    let(:work) { FactoryGirl.actor_create(:pdf, user: depositing_user) }
    let(:depositing_user) { FactoryGirl.create(:user) }

    it 'sets the workflow status to published' do
      PublishJob.perform_now(work.id)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"
      job.perform_now(work.id)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
    end
  end
end
