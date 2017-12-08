# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Audio', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }

    before { login_as user }

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"
      # If you generate more than one work uncomment these lines
      within('form.new-work-select') do
        select 'Audio', from: 'work-type-select-box'
        click_button "Create work"
      end
      expect(page).to have_content "Add New Audio"
      # We want the transcription UI to show up on the form
      expect(page).to have_content('You will need to attach an XML file to to this work to select a transcript.')

      # Fill out the form with require metadata and some sample data
      within('.audio_title') do
        fill_in "Title", with: "Example \nTitle   "
      end
      find(:xpath, '//option[contains(text(), "nowhere")]').select_option
      fill_in 'Abstract', with: 'Abstract'
      fill_in 'Accrual Policy', with: 'Accrual Policy'
      fill_in 'Alternate Title', with: 'Alternate Title'
      fill_in 'Audience', with: 'Audience'

      # Attach an MP3 file
      click_link "Files"
      execute_script("$('.fileinput-button input:first').css({'opacity':'1', 'display':'block', 'position':'relative'})")

      # Upload the TEI first, and the audio second
      # We want the audio to end up as the rep. media
      attach_file('files[]', File.absolute_path(file_fixture('tei.xml')))
      attach_file('files[]', File.absolute_path(file_fixture('sample.mp3')))
      sleep(1)
      find('#with_files_submit').click

      expect(page).to have_content 'Example Title'
      expect(page).to have_content 'nowhere'
      expect(page).to have_content 'Abstract'
      expect(page).to have_content 'Accrual Policy'
      expect(page).to have_content 'Alternate Title'
      expect(page).to have_content 'Audience'
    end
  end
end
