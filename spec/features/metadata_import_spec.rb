require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Import Metadata', :clean, js: true, batch: true do
  let!(:objects) { FactoryGirl.create_list(:pdf, 2) }
  let(:object)   { objects.first }
  let(:other)    { objects[1] }
  let(:user) { FactoryGirl.create(:admin) }

  before { ActiveJob::Base.queue_adapter = :test }

  context 'as admin' do
    before { login_as user }

    context 'happy path' do
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
  end
end
