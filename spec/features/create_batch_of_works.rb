require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a batch of works', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }

    before { login_as user }

    scenario do
      visit '/dashboard'
      click_link 'Works'
      expect(page).to have_content 'Create batch of works'
      click_link 'Create batch of works'
      within('form.new-work-select') do
        select 'PDF', from: 'work-type-select-box'
        click_button "Create work"
      end
      expect(page).to have_content 'Descriptions'
      click_link 'Descriptions'
      expect(page).not_to have_selector '#batch_upload_item_title'
      expect(page).to have_content 'Displays in'
      click_link 'Files'
      execute_script("$('.fileinput-button input:first').css({'opacity':'1', 'display':'block', 'position':'relative'})")
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      expect(page).to have_content('Display label')
      click_link 'Descriptions'
      find(:xpath, '//option[contains(text(), "nowhere")]').select_option
      click_link 'Files'
      find('#with_files_submit').click
      expect(page).to have_content 'Your Works'
      expect(page).to have_content 'Your files are being processed by MIRA in the background.'
    end
  end
end
