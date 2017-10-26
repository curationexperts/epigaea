require 'rails_helper'

describe Tufts::WorkflowStatus do
  let(:work) { create(:pdf) }
  let(:workflow_status) { subject }
  it 'returns unpublished for an unpublished work when given its ID' do
    expect(workflow_status.status(work.id)).to eq('unpublished')
  end
end
