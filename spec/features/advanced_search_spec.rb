require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'perform an advanced search', :clean do
  let(:pdf) { FactoryGirl.create(:pdf) }
  let(:another_pdf) { FactoryGirl.create(:populated_pdf) }
  let(:user) { FactoryGirl.create(:admin) }

  before { login_as user }

  scenario 'performing a basic search on the advanced search page' do
    visit '/advanced'
    expect(page).to have_content('More Search Options')
    fill_in 'Title', with: pdf.title[0]
    click_on 'Search'
    expect(page).to have_content(pdf.title[0])
    expect(page).not_to have_content(another_pdf.title[0])

    visit '/advanced'
    expect(page).to have_content('More Search Options')
    fill_in 'Date Created', with: pdf.date_created[0]
    click_on 'Search'
    expect(page).to have_content(pdf.title[0])
    expect(page).not_to have_content(another_pdf.title[0])
  end
end
