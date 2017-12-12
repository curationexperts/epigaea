require 'rails_helper'
require 'tufts/workflow_setup'
include Warden::Test::Helpers

RSpec.feature 'Links in the dashboard sidebar', :clean, js: true do
  context 'a logged in admin user' do
    let(:admin) { FactoryGirl.create(:admin) }

    before { login_as admin }

    scenario do
      visit '/dashboard'
      # Site functionality that shouldn't be accessible to
      # non-admin users
      expect(page).to have_link('Advanced Search')
      expect(page).to have_link('View Handle.net Error Log')
      expect(page).to have_link('View Batch Statuses')
      expect(page).to have_link('View Background Job Queues')
      expect(page).to have_link('Manage Metadata Templates')
      expect(page).to have_content('IMPORT/EXPORT')
      expect(page).to have_link('Import Objects')
      expect(page).to have_link('Import Metadata')
      expect(page).to have_link('Manage Self-Deposit Types')
    end
  end

  context 'a logged in non-admin user' do
    let(:user) { FactoryGirl.create(:user) }

    before { login_as user }

    scenario do
      visit '/notifications'
      # Site functionality that shouldn't be accessible to
      # non-admin users
      expect(page).not_to have_link('Advanced Search')
      expect(page).not_to have_link('View Handle.net Error Log')
      expect(page).not_to have_link('View Batch Statues')
      expect(page).not_to have_link('View Background Job Queues')
      expect(page).not_to have_link('Manage Metadata Templates')
      expect(page).not_to have_content('IMPORT/EXPORT')
      expect(page).not_to have_link('Import Objects')
      expect(page).not_to have_link('Import Metadata')
      expect(page).not_to have_link('Manage Self-Deposit Types')
      # Functionality that should still be accessible to
      # non-admin users in the dashboard
      expect(page).to have_content('REPOSITORY CONTENTS')
      expect(page).to have_link('New Self-Deposit Item')
    end
  end
end
