require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'viewing the batches page', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      login_as user
      rand(25..100).times { FactoryGirl.create(:batch) }
      visit '/batches'
    end

    scenario 'the server only renders 10 batches even if there are more' do
      expect(page).to have_css('tbody tr', count: 10)
    end

    scenario 'selecting more fetches more and renders them' do
      select '25', from: 'batch-table_length'
      expect(page).to have_css('tbody tr', count: 25)
    end
  end
end
