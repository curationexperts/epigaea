# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'batch', :batch, :clean, type: :feature, js: true do
  let(:current_user) { create(:admin) }
  let!(:work_first) { create(:pdf) }
  let!(:work_second) { create(:pdf) }

  before do
    login_as current_user
    visit '/dashboard/works'

    # Make sure the tests are set up correctly.
    # Only our 2 works should be displayed in the table.
    expect(page).to have_selector("#documents table tbody tr", count: 2)
  end

  describe 'publishing' do
    it 'sends the user to the batch status page like on the catalog' do
      check 'check_all'
      expect(page).to have_selector('.tufts-buttons')
      click_on 'Publish'
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'unpublishing' do
    it 'sends the user to the batch status page like on the catalog' do
      check 'check_all'
      expect(page).to have_selector('.tufts-buttons')
      click_on 'Unpublish'
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'exporting metadata' do
    it 'sends the user to the batch status page like on the catalog' do
      check 'check_all'
      expect(page).to have_selector('.tufts-buttons')
      click_on 'Export Metadata'
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'applying template' do
    it 'sends the user to the batch status page like on the catalog' do
      check 'check_all'
      expect(page).to have_selector('.tufts-buttons')
      click_on 'Apply Template'
      expect(page).to have_content('Template Behavior')
    end
  end
end
