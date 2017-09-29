require 'rails_helper'
require 'ffaker'
include Warden::Test::Helpers
require 'import_export/deposit_type_importer'

RSpec.feature 'submit an Undergraduate Honors Thesis contribution', js: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:csv_path) { Rails.root.join('config', 'deposit_type_seed.csv').to_s }
  let(:importer) { DepositTypeImporter.new(csv_path) }
  let(:pdf_path) { Rails.root.join('spec', 'fixtures', 'hello.pdf') }

  before do
    login_as user
    importer.import_from_csv
  end

  scenario do
    visit '/contribute'
    find('#deposit_type').find(:xpath, 'option[10]').select_option
    click_button 'Begin'
    attach_file('PDF to upload', pdf_path)
    fill_in 'Thesis title', with: FFaker::Book.title
    fill_in 'Contributor', with: FFaker::Book.author

    # Test department autocomplete
    fill_in 'Department', with: 'geol'
    page.execute_script %{ $('#contribution_department').trigger('focus') }
    page.execute_script %{ $('#contribution_department').trigger('keydown') }
    expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item')
    page.execute_script %{ $('ul.ui-autocomplete li.ui-menu-item:contains("Dept. of Geology")').trigger('mouseenter').click() }
    expect(find_field('Department').value).to eq 'Dept. of Geology'

    fill_in 'Short Description', with: FFaker::Book.description
    click_button 'Agree & Deposit'
    expect(page).to have_content 'Your deposit has been submitted for approval.'
  end
end
