# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Faculty Scholarship self contribution', :clean, js: true do
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
      user.display_name = "     Name   with   Spaces    "
      user.save
    end

    scenario "a new user contributes faculty scholarship" do
      visit '/contribute'
      select 'Faculty Scholarship', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in "Title", with: title
      fill_in "Bibliographic Citation", with: bibliographic_citation
      # fill_in "Other authors", with: other_author
      fill_in "Short Description", with: abstract
      click_button "Agree & Deposit"
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.creator.first).to eq "Name with Spaces"
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.description.first).to eq abstract
      expect(created_pdf.bibliographic_citation.first).to eq bibliographic_citation
      logout
      login_as(admin)
      visit("/concern/pdfs/#{created_pdf.id}")
      expect(page).to have_content(created_pdf.title.first)
      expect(page).to have_content(abstract)
      expect(page).to have_content(bibliographic_citation)
      visit("/concern/pdfs/#{created_pdf.id}/edit")
      expect(find_by_id("pdf_description").value).to eq abstract
      expect(find_by_id("pdf_bibliographic_citation").value).to eq bibliographic_citation
    end

    scenario "normalize spaces in entered fields" do
      visit '/contribute'
      select 'Faculty Scholarship', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in "Title", with: " Space   non normalized \n  title    "
      fill_in "Short Description", with: " A short   description    with  wonky spaces   "
      fill_in "Bibliographic Citation", with: " bibliographic   citation  \n with     spaces    "
      click_button "Agree & Deposit"
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq "Space non normalized title"
      expect(created_pdf.creator.first).to eq "Name with Spaces"
      expect(created_pdf.description.first).to eq "A short description with wonky spaces"
      expect(created_pdf.bibliographic_citation.first).to eq "bibliographic citation with spaces"
    end
  end
end
