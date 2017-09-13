require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'search bar on the index page' do
  context 'a logged in admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login_as admin }
    describe 'viewing the search bar as an admin' do
      scenario do
        visit '/'
        expect(page).to have_selector '#search-field-header'
      end
    end
  end
  context 'a non-admin user' do
    let(:user) { FactoryGirl.create(:user) }
    before { login_as user }

    describe 'viewing the error log as a non-admin user' do
      scenario do
        visit '/'
        expect(page).not_to have_selector 'search-field-header'
      end
    end
  end
  context 'a visitor who isn\'t logged in' do
    describe 'viewing the error log as a non-admin user' do
      scenario do
        visit '/'
        expect(page).not_to have_selector 'search-field-header'
      end
    end
  end
end
