# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PDF', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }

    before { login_as user }

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"
      # If you generate more than one work uncomment these lines
      within('form.new-work-select') do
        select 'PDF', from: 'work-type-select-box'
        click_button "Create work"
      end
      # Hyrax::BasicMetadata attributes that we don't want in the form
      expect(page).to have_no_content('Keywords')
      expect(page).to have_no_content('Location')
      # We don't want the transcript UI to show up on the Pdf form
      expect(page).not_to have_content('You will need to attach an XML file to to this work to select a transcript.')
      # Fill out the form with everything
      within('.pdf_title') do
        fill_in "Title", with: "Example \nTitle   "
      end
      find(:xpath, '//option[contains(text(), "nowhere")]').select_option
      fill_in 'Abstract', with: 'Abstract'
      fill_in 'Accrual Policy', with: 'Accrual Policy'
      fill_in 'Alternate Title', with: 'Alternate Title'
      fill_in 'Audience', with: 'Audience'
      fill_in 'Bibliographic Citation', with: 'Bibliographic Citation'
      fill_in 'Contributor', with: 'Contributor'
      fill_in 'Corporate Name', with: 'Corporate Name'
      fill_in 'Created By', with: 'Created By'
      fill_in 'Creator', with: 'Creator'
      fill_in 'Creator Department', with: 'Creator Department'
      fill_in 'Date Accepted', with: 'Date Accepted'
      fill_in 'Date Available', with: 'Date Available'
      fill_in 'Date Copyrighted', with: 'Date Copyrighted'
      fill_in 'Date Created', with: 'Date Created'
      fill_in 'Date Issued', with: 'Date Issued'
      fill_in 'Depositor', with: 'Depositor'
      fill_in 'Description', with: 'Description'
      fill_in 'Embargo Note', with: 'Embargo Note'
      fill_in 'End Date', with: 'End Date'
      fill_in 'Extent', with: 'Extent'
      fill_in 'Format', with: 'Format'
      fill_in 'Funder', with: 'Funder'
      fill_in 'Genre', with: 'Genre'
      fill_in 'Spatial', with: 'Spatial'
      fill_in 'Has Format', with: 'Has Format'
      fill_in 'Has Part', with: 'Has Part'
      fill_in 'Held By', with: 'Held By'
      fill_in 'Internal Note', with: 'Internal Note'
      fill_in 'Is Format Of', with: 'Is Format Of'
      fill_in 'Is Part Of', with: 'Is Part Of'
      fill_in 'Is Replaced By', with: 'Is Replaced By'
      fill_in 'Language', with: 'Language'
      fill_in 'Legacy PID', with: 'Legacy PID'
      fill_in 'License', with: 'License'
      fill_in 'Personal Name', with: 'Personal Name'
      fill_in 'Primary Date', with: 'Primary Date'
      fill_in 'Provenance', with: 'Provenance'
      fill_in 'Publisher', with: 'Publisher'
      fill_in 'QR Note', with: 'QR Note'
      fill_in 'QR Status', with: 'QR Status'
      fill_in 'QR Rejection Reason', with: 'QR Rejection Reason'
      fill_in 'Replaces', with: 'Replaces'
      fill_in 'Retention Period', with: 'Retention Period'
      fill_in 'Rights Holder', with: 'Rights Holder'
      fill_in 'Rights Note', with: 'Rights Note'
      fill_in 'Tufts License', with: 'Tufts License'
      # This is not working in Capybara
      select 'Springer Policy', from: 'Rights'
      expect(page).to have_select('Rights', selected: 'Springer Policy')
      fill_in 'Source', with: 'Source'
      fill_in 'Start Date', with: 'Start Date'
      fill_in 'Steward', with: 'Steward'
      fill_in 'Subject', with: 'Subject'
      fill_in 'Table of Contents', with: 'Table of Contents'
      fill_in 'Temporal', with: 'Temporal'
      fill_in 'Tufts License', with: 'Tufts License'
      select 'Text', from: 'Type'
      # Attach a file
      click_link "Files"

      execute_script("$('.fileinput-button input:first').css({'opacity':'1', 'display':'block', 'position':'relative'})")
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      sleep(1)
      find('#with_files_submit').click

      expect(page).to have_content 'Example Title'
      expect(page).to have_content 'Displays in Portal'
      expect(page).to have_content 'nowhere'
      expect(page).to have_content 'Abstract'
      expect(page).to have_content 'Accrual Policy'
      expect(page).to have_content 'Alternate Title'
      expect(page).to have_content 'Audience'
      expect(page).to have_content 'Bibliographic Citation'
      expect(page).to have_content 'Contributor'
      expect(page).to have_content 'Corporate Name'
      expect(page).to have_content 'Created By'
      expect(page).to have_content 'Creator'
      expect(page).to have_content 'Creator Department'
      expect(page).to have_content 'Date Accepted'
      expect(page).to have_content 'Date Available'
      expect(page).to have_content 'Date Copyrighted'
      expect(page).to have_content 'Date Created'
      expect(page).to have_content 'Date Issued'
      expect(page).to have_content 'Depositor'
      expect(page).to have_content 'Description'
      expect(page).to have_content 'Embargo Note'
      expect(page).to have_content 'End Date'
      expect(page).to have_content 'Extent'
      expect(page).to have_content 'Format'
      expect(page).to have_content 'Funder'
      expect(page).to have_content 'Genre'
      expect(page).to have_content 'Spatial'
      expect(page).to have_content 'Has Format'
      expect(page).to have_content 'Has Part'
      expect(page).to have_content 'Held By'
      expect(page).to have_content 'Internal Note'
      expect(page).to have_content 'Is Format Of'
      expect(page).to have_content 'Is Part Of'
      expect(page).to have_content 'Is Replaced By'
      expect(page).to have_content 'Language'
      expect(page).to have_content 'Legacy PID'
      expect(page).to have_content 'License'
      expect(page).to have_content 'Personal Name'
      expect(page).to have_content 'Primary Date'
      expect(page).to have_content 'Provenance'
      expect(page).to have_content 'Publisher'
      expect(page).to have_content 'QR Note'
      expect(page).to have_content 'QR Status'
      expect(page).to have_content 'QR Rejection Reason'
      expect(page).to have_content 'Replaces'
      expect(page).to have_content 'Retention Period'
      expect(page).to have_content 'Rights Holder'
      expect(page).to have_content 'Rights Note'
      expect(page).to have_content 'Tufts License'
      # This is not working with Capybara, but does work
      # there is a view test for the Rights Statement
      # in spec/views/hyrax/_attribute_rows.html.erb_spec.rb
      expect(page).to have_content 'Springer Policy'
      expect(page).to have_content 'Source'
      expect(page).to have_content 'Start Date'
      expect(page).to have_content 'Steward'
      expect(page).to have_content 'Subject'
      expect(page).to have_content 'Table of Contents'
      expect(page).to have_content 'Temporal'
      expect(page).to have_content 'Tufts License'
      expect(page).to have_content 'Text'
    end
  end
end
