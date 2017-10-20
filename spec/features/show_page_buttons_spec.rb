require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Mark as reviewed button', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:pdf) { FactoryGirl.create(:pdf) }

    before { login_as user }

    scenario do
      visit "/concern/pdfs/#{pdf.id}"
      # Specs for the buttons
      find('.mark-as-reviewed').click
      # The JS calls this as well, but Capybara doesn't seem to
      # triggering Turbolinks in the same way
      execute_script("Turbolinks.visit(window.location.href)")
      expect(page).to have_css('.mark-as-reviewed[disabled]')
    end
  end
end
