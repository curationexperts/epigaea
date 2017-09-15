require 'rails_helper'
require 'tufts/workflow_setup'
include Warden::Test::Helpers

RSpec.feature 'Manage Deposit Types link in dashboard sidebar', :clean do
  context 'a logged in user' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      Tufts::WorkflowSetup.setup
      login_as admin
    end

    scenario do
      visit '/dashboard'
      expect(page).to have_content "Manage self-deposit types"
    end
  end
end
