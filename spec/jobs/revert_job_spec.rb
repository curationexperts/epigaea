require 'rails_helper'

RSpec.describe RevertJob, :workflow, type: :job do
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

  context "revert a draft" do
    let(:work) { FactoryGirl.actor_create(:pdf, user: depositing_user) }
    let(:depositing_user) { FactoryGirl.create(:user) }

    before do
      work.title = ['testing']
      work.save_draft
    end

    it 'sets the workflow status to published' do
      expect(work.draft_saved?).to eq(true)
      RevertJob.perform_now(work.id)
      expect(work.draft_saved?).to eq(false)
    end
  end
end
