require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create and revert a draft', :clean, js: true do
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

      # expect(page).to have_content "Add New PDF"
      fill_in "Title", with: 'Example Title'
      find(:xpath, '//option[contains(text(), "nowhere")]').select_option
      click_link "Files"
      execute_script("$('.fileinput-button input:first').css({'opacity':'1', 'display':'block', 'position':'relative'})")
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      sleep(1)
      find('#with_files_submit').click
      expect(page).to have_content('Example Title')
      click_on 'Publish'
      sleep(1)
      click_on 'Edit'
      sleep(1)
      click_on 'Save Draft'
      expect(page).to have_content('Edited')
      click_on 'Revert Draft'
      expect(page).to have_content('Published')
      # Test to see if the draft has been deleted after saving the work
      click_on 'Save Draft'
      fill_in "Title", with: 'Example Title from Draft'
      fill_in "Abstract", with: 'Another abstract'
      sleep(1)
      click_on 'Save'
      click_on 'Edit'
      expect(page).to have_content('Published')
    end
  end
end
