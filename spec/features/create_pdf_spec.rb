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
      expect(page).to have_no_content('Keywords')
      expect(page).to have_no_content('Location')
      within('.pdf_title') do
        fill_in "Title", with: "Example \nTitle   "
      end
      fill_in "Creator", with: "A creator"
      find(:xpath, '//option[contains(text(), "nowhere")]').select_option
      click_link "Files"
      execute_script("$('.fileinput-button input:first').css({'opacity':'1', 'display':'block', 'position':'relative'})")
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      sleep(1)
      find('#with_files_submit').click
      expect(page).to have_content('Example Title')
    end
  end
end
