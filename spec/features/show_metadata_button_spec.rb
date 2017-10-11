require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PDF', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:pdf) { FactoryGirl.create(:pdf) }

    before { login_as user }

    scenario do
      visit "/concern/pdfs/#{pdf.id}"
      # Specs for the buttons
      find('.show-metadata').click

      expect(page).to have_current_path("/concern/pdfs/#{pdf.id}.ttl")
    end
  end
end
