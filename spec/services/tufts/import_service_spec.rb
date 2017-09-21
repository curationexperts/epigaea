require 'rails_helper'

describe Tufts::ImportService, :workflow do
  subject(:service) { described_class.new(file: file, import: import) }

  let(:file)   { FactoryGirl.create(:hyrax_uploaded_file) }
  let(:import) { FactoryGirl.create(:xml_import, uploaded_file_ids: [file.id]) }

  it { is_expected.to have_attributes(file: file, import: import) }

  describe '#import_object!' do
    it 'imports the object' do
      expect(service.import_object!).to be_persisted
    end

    it 'adds the file' do
      ActiveJob::Base.queue_adapter = :test

      expect { service.import_object! }
        .to enqueue_job(AttachFilesToWorkJob).once
    end
  end

  describe '#record' do
    it 'gets the record for the file' do
      expect(service.record).to have_attributes(file: file.file.filename)
    end
  end
end
