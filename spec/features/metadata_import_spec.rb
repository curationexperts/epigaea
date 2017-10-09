require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Import Metadata', :clean, js: true, batch: true do
  let(:file)     { file_fixture('mira_export.xml') }
  let!(:objects) { FactoryGirl.create_list(:pdf, 2) }
  let(:object)   { objects.first }
  let(:other)    { objects[1] }

  before { ActiveJob::Base.queue_adapter = :test }

  context 'as admin' do
    let(:user) { FactoryGirl.create(:admin) }

    before { login_as user }

    scenario 'import metadata from file' do
      visit '/metadata_imports/new'

      attach_file 'metadata_file', file

      expect { click_button 'Next' }
        .to enqueue_job(MetadataImportJob)
        .exactly(5).times

      expect(page).to have_content 'Batch'
    end
  end
end
