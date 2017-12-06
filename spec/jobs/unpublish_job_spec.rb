require 'rails_helper'

RSpec.describe UnpublishJob, :workflow, type: :job do
  subject(:job) { described_class }
  let(:pdf) { FactoryGirl.create(:pdf) }

  describe '#perform_later' do
    it 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect { job.perform_later(pdf.id) }
        .to enqueue_job(described_class)
        .with(pdf.id)
        .on_queue('batch')
    end
  end

  context "workflow transition" do
    let(:work) { FactoryGirl.create(:pdf) }
    let(:depositing_user) { FactoryGirl.create(:user) }
    before do
      allow(CharacterizeJob).to receive(:perform_later) # Don't run fits
      current_ability = ::Ability.new(depositing_user)
      attributes = {}
      env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
      Hyrax::CurationConcern.actor.create(env)
    end
    it 'sets the workflow status to published' do
      PublishJob.perform_now(work.id)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"
      job.perform_now(work.id)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
    end
  end
end
