require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'login and logout', :clean do
  let(:admin) { create(:admin) }

  context 'logging in' do
    scenario 'provide a login and password' do
      skip "This test will only work if Ladle (or other LDAP) is running. Disabled for CI."
      # It's a good way to test that LDAP authentication is working as expected,
      # but we don't need to load LDAP auth every time we run our CI tests.
      u = User.create(email: 'admin@example.org', username: 'admin', display_name: 'Admin, Example', password: 'password')
      u.add_role('admin')
      u.save
      visit '/dashboard'
      expect(current_path).to eq "/contribute"
      find('a.btn-primary').click
      expect(current_path).to eq "/users/sign_in"
      fill_in 'user_username', with: u.user_key
      fill_in 'user_password', with: u.password
      click_on 'Log in'
      expect(current_path).to eq "/dashboard"
    end
  end

  context 'when logged in' do
    before { login_as admin }

    scenario 'logging out' do
      visit '/dashboard'

      within '#user_utility_links' do
        click_on 'Logout'
      end

      expect(page).to have_content 'Login'
    end
  end
end
