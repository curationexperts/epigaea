require 'rails_helper'
require 'tufts/workflow_setup'

RSpec.describe Tufts::WorkflowSetup do
  let(:w) { described_class.new }
  let(:admin_user) { FactoryGirl.create(:admin) }

  it "sets the default admin set to use the mira workflow and runs idempotently" do
    w.set_default_workflow
    a = AdminSet.find(AdminSet::DEFAULT_ID)
    expect(a.active_workflow.name).to eq Tufts::WorkflowSetup::MIRA_WORKFLOW_NAME
    w.set_default_workflow
    b = AdminSet.find(AdminSet::DEFAULT_ID)
    b.reload
    # it has not created a new workflow with the same name
    expect(b.active_workflow).to eq a.active_workflow
  end
  it "grants the workflow approval role to all members of the hyrax admin group" do
    w.setup
    a = AdminSet.find(AdminSet::DEFAULT_ID)
    workflow = a.active_workflow
    expect(a.active_workflow.name).to eq Tufts::WorkflowSetup::MIRA_WORKFLOW_NAME

    # Check workflow permissions for admin user
    roles = Hyrax::Workflow::PermissionQuery.scope_processing_workflow_roles_for_user_and_workflow(
      user: admin_user,
      workflow: workflow
    )
    role_names = roles.map { |r| Sipity::Role.find(r.role_id).name }

    expect(role_names).to contain_exactly(
      "publishing"
    )
  end
end
