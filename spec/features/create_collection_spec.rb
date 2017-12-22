# Generated via
#  `rails generate hyrax:work Ead`
require 'rails_helper'
require 'ffaker'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Collection', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:title) { FFaker::Book.title }
    let(:ead_id) { 'fake_ead_id' }

    before { login_as user }

    scenario do
      visit '/dashboard'
      click_link "Collections"
      click_link "New Collection"

      # EAD is a form entry field when you create a new Collection
      fill_in 'Title', with: title
      fill_in 'EAD', with: ead_id
      click_button "Create Collection"

      # EAD id is displayed on the Collection page within the admin dashboard
      expect(page).to have_content "EAD"
      expect(page).to have_content ead_id

      # EAD id is displayed on the Collection page outside the admin dashboard
      c = Collection.last
      visit "/collections/#{c.id}"
      expect(page).to have_content "EAD"
      expect(page).to have_content ead_id
    end
  end
end
