require 'rails_helper'

RSpec.describe HandleUpdateJob, type: :job do
  subject(:job) { described_class }
  let(:pdf)     { create(:pdf) }

  describe '#perform_later' do
    it 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect { job.perform_later(pdf) }
        .to enqueue_job(described_class)
        .with(pdf)
        .on_queue('handle')
    end
  end
end
