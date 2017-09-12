require 'rails_helper'
require 'tufts/workflow_setup'

RSpec.describe Tufts::WorkflowSetup do
  let(:w) { described_class.new }
  it "sets the default admin set to use the mira workflow" do
    w.set_default_workflow
    a = ::AdminSet.find("admin_set/default")
    expect(a.active_workflow.name).to eq "mira_publication_workflow"
  end
end
