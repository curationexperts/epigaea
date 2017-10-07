# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PDF', :clean, js: true do
  context do
    let(:depositing_user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:title) { FFaker::Movie.title }
    let(:short_description) { FFaker::Lorem.paragraphs(6).join("\n") }
    before do
      importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
      login_as depositing_user
    end

    scenario "a new user contributes undergraduate research" do
      visit '/contribute'
      select 'General Undergraduate Scholarship', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in "Title", with: title
      fill_in "Contributor", with: depositing_user.display_name
      fill_in "Short Description", with: short_description
      click_button "Agree & Deposit"
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.contributor.first).to eq depositing_user.display_name
      expect(created_pdf.depositor).to eq depositing_user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.description.first[0...100]).to eq short_description[0...100]
      # Check notifications for depositing user
      login_as depositing_user
      visit("/notifications?locale=en")
      expect(page).to have_content "#{created_pdf.title.first} (#{created_pdf.id}) has been deposited by #{depositing_user.display_name} (#{depositing_user.user_key}) and is awaiting publication."
      logout
      login_as(admin)
      visit("/concern/pdfs/#{created_pdf.id}")
      expect(page).to have_content(title)
      expect(page).to have_content(short_description)
      visit("/concern/pdfs/#{created_pdf.id}/edit")
      expect(find_by_id("pdf_description").value).to eq short_description
    end
  end
end
