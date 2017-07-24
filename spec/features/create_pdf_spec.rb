# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PDF', :clean, js: true do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

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
      find('#agreement').click
      sleep(1)
      find('#with_files_submit').click
      expect(page).to have_content('Example Title')
    end
  end
end
