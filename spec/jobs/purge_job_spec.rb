require 'rails_helper'

RSpec.describe PurgeJob, :workflow, type: :job do
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

  context "purging a work" do
    let(:work) { FactoryGirl.actor_create(:pdf, user: depositing_user) }
    let(:depositing_user) { FactoryGirl.create(:user) }

    before do
      Pdf.destroy_all
    end
    it 'removes the work that was created' do
      work.title = ['test']
      work.save
      expect(Pdf.count).to eq(1)
      PurgeJob.perform_now(work.id)
      expect(Pdf.count).to eq(0)
    end
  end
end
