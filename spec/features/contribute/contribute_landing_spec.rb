require 'rails_helper'
require 'ffaker'
require 'import_export/deposit_type_importer.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Self Deposit', :clean, js: true do
  context "all deposit types" do
    let(:csv_path) { Rails.root.join('config', 'deposit_type_seed.csv').to_s }
    let(:importer) { DepositTypeImporter.new(csv_path) }
    let(:user) { FactoryGirl.create(:user) }

    before do
      importer.import_from_csv
    end

    scenario "unauthenticated users" do
      visit '/contribute'
      expect(page).to have_content DepositType.first.display_name
      expect(page).to have_content DepositType.last.display_name
      expect(page).to have_link href: new_user_session_path
    end

    scenario "authenticated users" do
      login_as user
      visit '/contribute'
      expect(page).to have_select 'deposit_type', with_options: [DepositType.first.display_name, DepositType.last.display_name]
      expect(page).to have_button 'Begin'
    end
  end
end
