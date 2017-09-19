require 'rails_helper'
include Warden::Test::Helpers
require 'import_export/deposit_type_importer'

RSpec.feature 'Get a flash message when choosing the placeholder option' do
  context 'a logged in user' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      login_as user
      importer = DepositTypeImporter.new(Rails.root.join('config','deposit_type_seed.csv').to_s)
      importer.import_from_csv
    end

    scenario do
      visit '/contribute'
      find('#deposit_type').find(:xpath, 'option[2]').select_option
      click_button 'Begin'
      expect(page).to have_content('Contribute a new document')
    end
  end
end
