# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Contribute GIS Expo Student Winners', :clean, js: true do
  context do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:title) { FFaker::Movie.title }
    let(:bibliographic_citation) { FFaker::Book.genre }
    let(:abstract) { FFaker::Book.description }
    let(:other_author) { FFaker::Name.name }
    before do
      importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
      login_as user
    end

    scenario "GIS Expo Student Winners" do
      visit '/contribute'
      select 'GIS Expo Student Winners', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in 'Title', with: title
      check 'Masters'
      check 'The Fletcher School'
      check 'Food Policy & Applied Nutr'
      check 'CEE 194A: Introduction to Remote Sensing'
      fill_in 'Place', with: "Washington"
      check 'Remote Sensing'
      click_button 'Agree & Deposit'
      expect(page).to have_content 'Your deposit has been submitted for approval.'
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.creator.first).to eq user.display_name
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.description).to include("Masters", "CEE 194A: Introduction to Remote Sensing")
      logout
      login_as(admin)
      visit("/concern/pdfs/#{created_pdf.id}")
      expect(page).to have_content(title)
      expect(page).to have_content('CEE 194A: Introduction to Remote Sensing')
    end
  end
end
