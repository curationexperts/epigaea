require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Empty string in rights statement', :clean, js: false do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:pdf) { FactoryGirl.create(:pdf) }

    before do
      login_as user
      pdf.rights_statement = [""]
      pdf.save
    end

    scenario do
      visit "/concern/pdfs/#{pdf.id}"
      expect(page).to have_content pdf.title.first
    end
  end
end
