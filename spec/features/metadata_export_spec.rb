require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Export Metadata', :clean, js: true, batch: true do
  let!(:objects) { [object, other] }
  let(:object)   { create(:pdf) }
  let(:other)    { create(:pdf) }

  context 'with logged in user' do
    let(:user) { FactoryGirl.create(:admin) }

    before do
      ActiveJob::Base.queue_adapter = :test

      login_as user
    end

    scenario 'export metadata for selected items' do
      visit '/catalog'

      objects.each do |obj|
        find("#document_#{obj.id}").check "batch_document_#{obj.id}"
      end

      expect { click_on 'Export Metadata' }
        .to enqueue_job(MetadataExportJob)
        .once

      expect(page).to have_content 'Download'
    end

    context 'with a generated file' do
      let(:contents) { '<?xml version="1.0" encoding="UTF-8"?><blah></blah>' }
      let(:filename) { 'moomin.xml' }

      let!(:export) { FactoryGirl.create(:metadata_export, filename: filename) }

      before { File.open(export.path, 'w') { |f| f.write(contents) } }
      after  { File.delete(export.path) }

      scenario 'downloading an export' do
        visit "batches/#{export.batch.id}"
        click_on(filename)

        expect(page.response_headers['Content-Disposition'])
          .to include 'attachment'
      end
    end
  end
end
