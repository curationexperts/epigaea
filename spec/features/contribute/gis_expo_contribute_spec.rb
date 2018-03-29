require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'GIS Expo Student Winners', :clean, js: true do
  context 'self deposit' do
    let(:csv_path) { Rails.root.join('config', 'deposit_type_seed.csv').to_s }
    let(:importer) { DepositTypeImporter.new(csv_path) }
    let(:test_pdf) { Rails.root.join('spec', 'fixtures', 'files', 'pdf-sample.pdf') }
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:title) { FFaker::Movie.unique.title }
    let(:bibliographic_citation) { FFaker::Book.genre }
    let(:other_author) { FFaker::Name.name }
    before do
      allow(CharacterizeJob).to receive(:perform_later).and_return(true) # Don't run fits
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
    end

    scenario 'contributions save as expected' do
      login_as user
      visit '/contribute'
      select 'GIS Expo Student Winners', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', test_pdf)
      fill_in 'contribution_title', with: title
      check 'Masters'
      check 'The Fletcher School'
      check 'Food Policy & Applied Nutr'
      check 'CEE 194A: Introduction to Remote Sensing'
      fill_in 'contribution_geonames_placeholder', with: "Washington"
      check 'Remote Sensing'
      click_button 'Agree & Deposit'
      expect(page).to have_content 'Your deposit has been submitted for approval.'

      created_pdf = Pdf.where(title: title).first
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.creator.first).to eq user.display_name
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.description).to include("Masters", "CEE 194A: Introduction to Remote Sensing")
      expect(created_pdf.abstract).to be_empty
      expect(created_pdf.member_of_collections.first.identifier.first).to eq("tufts:UA069.001.DO.PB")
      logout

      login_as admin
      visit("/concern/pdfs/#{created_pdf.id}")
      expect(page).to have_content(title)
      expect(page).to have_content('CEE 194A: Introduction to Remote Sensing')
    end
  end
end
