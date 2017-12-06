require 'rails_helper'

describe Tufts::WorkflowStatus, :workflow, :clean do
  let(:work) { Pdf.new(title: ['Title'], displays_in: ['nowhere'], description: ['A desc']) }
  let(:current_user) { FactoryGirl.create(:admin) }
  let(:workflow_status) { subject }

  before do
    work.save
    current_ability = ::Ability.new(current_user)
    uploaded_file = Hyrax::UploadedFile.create(user: current_user, file: File.open(Rails.root.join('spec', 'fixtures', 'hello.pdf'), 'r'))
    attributes = { uploaded_files: [uploaded_file.id] }
    env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
    Hyrax::CurationConcern.actor.create(env)
    work.update(admin_set: AdminSet.find(AdminSet::DEFAULT_ID))
  end

  it 'returns unpublished for an unpublished work when given its ID' do
    expect(workflow_status.status(work.id)).to eq('unpublished')
  end

  it 'returns published for an published work when given its ID' do
    subject = Hyrax::WorkflowActionInfo.new(work, current_user)
    sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
    Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Published by #{current_user}")
    expect(workflow_status.status(work.id)).to eq('published')
  end

  it 'returns edited for an published work that has a draft when given its ID' do # rubocop:disable RSpec/ExampleLength
    subject = Hyrax::WorkflowActionInfo.new(work, current_user)
    sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
    Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Published by #{current_user}")
    File.open(Rails.application.config.drafts_storage_dir.join(work.id), 'w+')
    expect(workflow_status.status(work.id)).to eq('edited')
    File.delete(Rails.application.config.drafts_storage_dir.join(work.id))
  end

  describe "#publish" do
    # rubocop:disable RSpec/MultipleExpectations
    it "publishes a work" do
      expect(workflow_status.status(work.id)).to eq('unpublished')
      Tufts::WorkflowStatus.publish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      expect(workflow_status.status(work.id)).to eq('published')
      Tufts::WorkflowStatus.publish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      expect(workflow_status.status(work.id)).to eq('published')
    end
    context "when displays in dl" do
      let(:work) { create(:pdf, displays_in: ['dl']) }
      before do
        ActiveJob::Base.queue_adapter = :test
      end
      it "enqueues a handle registration job" do
        expect { described_class.publish(work: work, current_user: current_user, comment: "rspec test for handle enqueue") }.to enqueue_job(HandleRegisterJob).with(work)
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
  describe "#unpublish" do
    # rubocop:disable RSpec/MultipleExpectations
    # rubocop:disable RSpec/ExampleLength
    it "unpublishes a work" do
      expect(workflow_status.status(work.id)).to eq('unpublished')
      Tufts::WorkflowStatus.publish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      expect(workflow_status.status(work.id)).to eq('published')
      Tufts::WorkflowStatus.unpublish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      expect(workflow_status.status(work.id)).to eq('unpublished')
      Tufts::WorkflowStatus.unpublish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      expect(workflow_status.status(work.id)).to eq('unpublished')
    end
    # rubocop:enable RSpec/MultipleExpectations
    # rubocop:enable RSpec/ExampleLength
  end
end
