require 'rails_helper'

RSpec.describe MetadataExportJob, type: :job do
  subject(:job) { described_class }
  let(:pdf)     { create(:pdf) }

  it_behaves_like 'an ActiveJob job'
end
