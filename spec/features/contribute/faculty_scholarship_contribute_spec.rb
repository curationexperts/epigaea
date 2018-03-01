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
    let(:coauthor1) { FFaker::Name.name }
    let(:coauthor2) { FFaker::Name.name }

    before do
      allow(CharacterizeJob).to receive(:perform_later).and_return(true) # Don't run fits
      importer = DepositTypeImporter.new('./config/deposit_type_seed.csv')
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
      login_as user
      user.display_name = "     Name   with   Spaces    "
      user.save

      allow(Time).to receive(:now).and_return Time.utc(2015, 1, 1, 12, 0, 0)
    end

    scenario "a new user contributes faculty scholarship" do
      visit '/contribute'
      select 'Faculty Scholarship', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', File.absolute_path(file_fixture('pdf-sample.pdf')))
      fill_in "Title", with: title
      fill_in "Bibliographic Citation", with: bibliographic_citation
      click_button "Add Another Author"
      # fill_in "Other Authors", with: coauthor1
      page.all(:fillable_field, 'contribution[contributor][]')[0].set(coauthor1)
      click_button "Add Another Author"
      page.all(:fillable_field, 'contribution[contributor][]')[1].set(coauthor2)
      select '6 months', from: 'contribution_embargo'
      fill_in "Short Description", with: abstract
      click_button "Agree & Deposit"
      created_pdf = Pdf.last
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.creator.first).to eq "Name with Spaces"
      expect(created_pdf.contributor).to contain_exactly coauthor1, coauthor2
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.description.first).to eq abstract
      expect(created_pdf.bibliographic_citation.first).to eq bibliographic_citation
      expect(created_pdf.embargo_note).to eq "2015-07-01T12:00:00Z"
      logout
      login_as(admin)
      visit("/concern/pdfs/#{created_pdf.id}")
      expect(page).to have_content(created_pdf.title.first)
      expect(page).to have_content(abstract)
      expect(page).to have_content(bibliographic_citation)
      expect(page).to have_content("In Collection")
      expect(page).to have_content("Tufts Published Scholarship, 1987-2014")
      expect(page).to have_content('Embargo Note')
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
      expect(created_pdf.embargo_note).to be_nil
    end
  end
end
