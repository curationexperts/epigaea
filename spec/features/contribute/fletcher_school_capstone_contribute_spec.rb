require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Fletcher School Capstone ProjectF', :clean, js: true do
  context 'self deposit' do
    let(:csv_path) { Rails.root.join('config', 'deposit_type_seed.csv').to_s }
    let(:importer) { DepositTypeImporter.new(csv_path) }
    let(:test_pdf) { Rails.root.join('spec', 'fixtures', 'files', 'pdf-sample.pdf') }
    let(:user) { FactoryGirl.create(:user) }
    let(:title) { FFaker::Movie.unique.title }
    let(:abstract) { FFaker::Book.description }
    before do
      allow(CharacterizeJob).to receive(:perform_later).and_return(true) # Don't run fits
      importer.import_from_csv
      Pdf.delete_all
      Hyrax::UploadedFile.delete_all
      login_as user
    end

    scenario 'contributions are saved as expected' do
      visit '/contribute'
      select 'Fletcher School Capstone Project', from: 'deposit_type'
      click_button "Begin"
      attach_file('contribution_attachment', test_pdf)
      fill_in "contribution_title", with: title
      fill_in "contribution_abstract", with: abstract
      select 'Master of Arts', from: 'contribution_degree'
      click_button "Agree & Deposit"
      expect(page).to have_content 'Your deposit has been submitted for approval.'

      created_pdf = Pdf.where(title: title).first
      expect(created_pdf.title.first).to eq title
      expect(created_pdf.creator.first).to eq user.display_name
      expect(created_pdf.depositor).to eq user.user_key
      expect(created_pdf.abstract.first).to eq abstract
      expect(created_pdf.description.first).to eq "Submitted in partial fulfillment of the degree Master of Arts at the Fletcher School of Law and Diplomacy."
      expect(created_pdf.admin_set.title.first).to eq "Default Admin Set"
      expect(created_pdf.active_workflow.name).to eq "mira_publication_workflow"
      expect(created_pdf.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      expect(created_pdf.member_of_collections.first.identifier.first).to eq("tufts:UA069.001.DO.UA015")
    end
  end
end
