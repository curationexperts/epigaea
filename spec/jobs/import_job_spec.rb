require 'rails_helper'

RSpec.describe ImportJob, type: :job do
  subject(:job) { described_class }

  describe '#perform_later' do
    xit 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test
    end
  end
end
