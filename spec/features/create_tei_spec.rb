# Generated via
#  `rails generate hyrax:work Tei`
require 'rails_helper'
require 'tufts/workflow_setup'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a TEI', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }

    before do
      Tufts::WorkflowSetup.setup
      login_as user
    end

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"
      # If you generate more than one work uncomment these lines
      within('form.new-work-select') do
        select 'TEI', from: 'work-type-select-box'
        click_button "Create work"
      end
      expect(page).to have_content "Add New TEI"
    end
  end
end
