require 'rails_helper'

RSpec.describe ImportJob, type: :job do
  subject(:job) { described_class }

  let(:file)   { FactoryGirl.create(:hyrax_uploaded_file) }
  let(:import) { FactoryGirl.create(:xml_import, uploaded_file_ids: [file.id]) }
  let(:pdf)    { FactoryGirl.create(:pdf) }

  describe '#perform_later' do
    it 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test

      expect { job.perform_later(import, file, pdf.id) }
        .to enqueue_job(described_class)
        .with(import, file, pdf.id)
        .on_queue('batch')
    end
  end
end
