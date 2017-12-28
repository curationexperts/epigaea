require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Import Metadata', :clean, js: true, batch: true do
  let!(:objects) { FactoryGirl.create_list(:pdf, 2) }
  let(:object)   { objects.first }
  let(:other)    { objects[1] }
  let(:user) { FactoryGirl.create(:admin) }
  let(:mira_export_ids) { ['7s75dc36z', 'wm117n96b', 'pk02c9724', 'xs55mc046', 'j67313767'] }

  before { ActiveJob::Base.queue_adapter = :test }

  context 'as admin' do
    before { login_as user }

    context 'happy path' do
      before do
        # All of the files we are updating must exist before the metadata import object can be created
        mira_export_ids.each do |id|
          FactoryGirl.create(:pdf, id: id)
        end
      end
      let(:file) { file_fixture('mira_export.xml') }
      scenario 'import metadata from file' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        expect { click_button 'Next' }
          .to enqueue_job(MetadataImportJob)
          .exactly(5).times
        expect(page).to have_content 'Batch'
      end
    end

    context 'date_modified field' do
      let(:work_id) { 'date_testing_id' }
      let(:work_title) { ['Original Title'] }
      let(:work) { FactoryGirl.create(:pdf, id: work_id, title: work_title) }
      let(:file) { file_fixture('metadata_import_date_testing.xml') }
      scenario 'is updated after metadata import' do
        ActiveJob::Base.queue_adapter = :inline
        expect(work.title).to eq work_title
        expect(work.date_modified).to be_nil
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Batch'
        expect(page).to have_content('Completed')
        work.reload
        expect(work.title).to eq ["Post Import Title"]
        expect(work.date_modified).to be_instance_of(DateTime)
        visit("/concern/pdfs/#{work_id}")
        expect(page).to have_content "Modified #{work.date_modified.strftime('%Y-%m-%d')}"
      end
    end

    context 'when file is malformed' do
      let(:file) { file_fixture('malformed_files/metadata_update/metadata_stray_element.xml') }
      scenario 'inform the user of malformed xml errors' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Error'
        expect(page).to have_content 'Malformed XML'
      end
    end

    context 'when file is missing required fields' do
      let(:file) { file_fixture('malformed_files/metadata_update/metadata_missing_required_fields.xml') }
      scenario 'inform the user of missing fields' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Error'
        expect(page).to have_content 'Missing required field: mst3k is missing dc:title'
        expect(page).to have_content 'Missing required field: mst3k is missing tufts:displays_in'
        expect(page).to have_content 'Missing required field: mst3k is missing model:hasModel'
        expect(page).not_to have_content 'A file was missing'
      end
    end

    context 'when file specifies nonexistent collection ids' do
      let(:file) { file_fixture('malformed_files/metadata_update/metadata_nonexistent_collection.xml') }
      scenario 'inform the user that the specified collection does not exist' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Error'
        expect(page).to have_content 'Cannot find collection with id fake for mst3k'
      end
    end

    context 'when file has more than one id for a record' do
      let(:file) { file_fixture('malformed_files/metadata_update/metadata_multiple_ids.xml') }
      scenario 'inform the user that only one id per record is permitted' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Error'
        expect(page).to have_content 'Only one id field can be specified per metadata import record'
      end
    end

    context 'when file has an invalid id' do
      let(:file) { file_fixture('mira_export.xml') }
      scenario 'inform the user that the id is invalid' do
        allow(ActiveFedora::Base).to receive(:find).and_raise(ActiveFedora::ObjectNotFoundError)
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'
        expect(page).to have_content 'Error'
        expect(page).to have_content '7s75dc36z is not a valid object id'
      end
    end

    context 'with collections' do
      let(:file)             { file_fixture('mira_export_with_collections.xml') }
      let(:collections)      { [collection_1, collection_2, collection_3] }
      let(:collection_1)     { create(:collection, id: 'collection_1') }
      let(:collection_2)     { create(:collection, id: 'collection_2') }
      let(:collection_3)     { create(:collection, id: 'collection_3') }
      let(:other_collection) { create(:collection) }

      let(:pdf) do
        create(:pdf, id: 'test_pdf_with_collections', member_of_collections: [other_collection])
      end

      before do
        pdf         # create pdf
        collections # create collections
        ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
        ActiveJob::Base.queue_adapter.filter = [MetadataImportJob]
      end

      scenario 'import into collections' do
        visit '/metadata_imports/new'
        attach_file 'metadata_file', file
        click_button 'Next'

        item = ActiveFedora::Base.find(find('.record_id').text)

        expect(item.member_of_collections).to contain_exactly(*collections)
      end
    end
  end
end
