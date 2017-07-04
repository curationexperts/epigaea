# Generated via
#  `rails generate hyrax:work VotingRecord`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a VotingRecord', :clean, js: true do
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
      choose "payload_concern", option: "VotingRecord"
      sleep(1)
      click_button "Create work"
      sleep(1)
      expect(page).to have_content "Add New Voting Record"
    end
  end
end
