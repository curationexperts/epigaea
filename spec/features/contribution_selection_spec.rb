require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Get a flash message when choosing the placeholder option' do
  context 'a logged in user' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      login_as user
    end

    scenario do
      visit '/contribute'
      click_on 'Begin'
      expect(page).to have_content('Please select a deposit type from the dropdown menu.')
    end
  end
end
