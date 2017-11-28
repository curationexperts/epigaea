require 'rails_helper'

describe Tufts::ImportService, :workflow do
  subject(:service) { described_class.new(file: file, import: import, object_id: object_id) }

  let(:file)   { FactoryGirl.create(:hyrax_uploaded_file) }
  let(:import) { FactoryGirl.create(:xml_import, uploaded_file_ids: [file.id]) }
  let(:object) { FactoryGirl.build(:pdf, id: object_id) }
  let(:object_id) { SecureRandom.uuid }

  it 'has file, import and object_ids attributes' do
    is_expected.to have_attributes(file:      file,
                                   import:    import,
                                   object_id: object_id)
  end

  describe '#import_object!' do
    it 'imports the object' do
      expect(service.import_object!).to be_persisted
    end

    it 'keeps the object id' do
      expect(service.import_object!).to have_attributes(id: object_id)
    end

    it 'adds the file' do
      ActiveJob::Base.queue_adapter = :test

      expect { service.import_object! }
        .to enqueue_job(AttachFilesToWorkJob).once
    end

    it 'has the title from the imported record' do
      title = "President Jean Mayer speaking\n          at commencement, 1987"

      expect(service.import_object!).to have_attributes(title: [title])
    end
  end

  describe '#record' do
    it 'gets the record for the file' do
      expect(service.record).to have_attributes(file: file.file.filename)
    end
  end
end
