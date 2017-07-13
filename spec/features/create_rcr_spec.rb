# Generated via
#  `rails generate hyrax:work Rcr`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create an RCR', :clean, js: true do
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
      sleep(1)
      # If you generate more than one work uncomment these lines
      within('form.new-work-select') do
        select 'RCR', from: 'work-type-select-box'
        click_button "Create work"
      end
      expect(page).to have_content "Add New RCR"
    end
  end
end
