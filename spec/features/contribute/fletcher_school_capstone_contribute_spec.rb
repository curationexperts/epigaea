# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PDF', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:title) { FFaker::Movie.title }
    before do
      importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
      login_as user
    end

    scenario "a new user contributes a capstone project" do
      visit '/contribute'
      select 'Fletcher School Capstone Project', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in "Capstone Project Title", with: title
      fill_in "Contributor", with: user.display_name
      select 'Master of Arts', from: 'contribution_degree'
      fill_in "Short Description", with: FFaker::Lorem.paragraph
      click_button "Agree & Deposit"
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.contributor.first).to eq user.display_name
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
