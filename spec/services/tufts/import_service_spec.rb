require 'rails_helper'

describe Tufts::ImportService, :workflow, :clean do
  subject(:service) { described_class.new(files: files, import: import, object_id: object_id) }

  let(:files)          { [FactoryGirl.create(:hyrax_uploaded_file)] }
  let(:import)         { FactoryGirl.create(:xml_import, uploaded_file_ids: files.map(&:id)) }
  let(:object)         { FactoryGirl.build(:pdf, id: object_id) }
  let(:object_id)      { SecureRandom.uuid }
  let(:collection1)     { FactoryGirl.create(:collection, id: 'a_collection_id') }
  let(:collection2)     { FactoryGirl.create(:collection, id: 'another_collection_id') }
  let(:collections)    { collection_ids.map { |id| FactoryGirl.create(:collection, id: id) }.to_a }
  let(:collection_ids) { import.records.first.collections }

  before do
    collection1
    collection2
    collections
  end

  it 'has file, import and object_ids attributes' do
    is_expected.to have_attributes(file:      files.first,
                                   import:    import,
                                   object_id: object_id,
                                   files:     files)
  end

  describe '#import_object!' do
    it 'imports the object' do
      expect(service.import_object!).to be_persisted
    end

    it 'keeps the object id' do
      expect(service.import_object!).to have_attributes(id: object_id)
    end

    it 'has the title from the imported record' do
      title = "President Jean Mayer speaking\n          at commencement, 1987"

      expect(service.import_object!).to have_attributes(title: [title])
    end

    it 'adds the file to a collection' do
      expect(service.import_object!.member_of_collections.map(&:id))
        .to contain_exactly(*collection_ids)
    end

    context 'when attaching uploaded files', :perform_enqueued do
      before { ActiveJob::Base.queue_adapter.filter = [AttachTypedFilesToWorkJob] }

      it 'adds a representative file' do
        result = service.import_object!
        result.reload

        expect(result.representative)
          .to have_attributes(title: ['pdf-sample.pdf'])
      end

      context 'with types' do
        let(:object) { FactoryGirl.build(:pdf, id: object_id) }
        let(:user)   { FactoryGirl.create(:admin) }

        let(:import) do
          FactoryGirl.create(:xml_import,
                             metadata_file: File.open(file_fixture('mira_xml_file_types.xml')),
                             uploaded_file_ids: files.map(&:id))
        end

        let(:files) do
          [FactoryGirl.create(:hyrax_uploaded_file,  user: user),
           FactoryGirl.create(:second_uploaded_file, user: user)]
        end

        it 'adds a representative and transcript' do
          result = service.import_object!
          result.reload

          expect(result)
            .to have_attributes(representative: have_attributes(title: ['pdf-sample.pdf']),
                                transcript:     have_attributes(title: ['2.pdf']))
        end
      end
    end

    context 'when the object exists' do
      before { object.save }

      it 'raises an error' do
        expect { service.import_object! }.to raise_error described_class::ImportError
      end
    end
  end

  describe '#record' do
    it 'gets the record for the file' do
      expect(service.record).to have_attributes(file: files.first.file.filename)
    end
  end
end
