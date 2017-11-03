require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'perform an advanced search', :clean do
  let(:pdf) { FactoryGirl.create(:pdf) }
  let(:user) { FactoryGirl.create(:admin) }

  before { login_as user }

  scenario do
    visit '/advanced'
    expect(page).to have_content('More Search Options')
    fill_in 'Creator', with: pdf.creator
    click_on 'Search'
    expect(page).to have_content(pdf.id)
  end
end
