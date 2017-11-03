# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'batch', type: :feature, clean_repo: true, js: true do
  let(:current_user) { create(:admin) }
  let(:work1)       { create(:populated_pdf) }
  let(:work2)       { create(:populated_pdf) }

  before do
    login_as current_user
    visit '/dashboard/works'
    check 'check_all'
    expect(page).to have_xpath("//div[contains(@class, 'tufts-buttons')]")
  end

  describe 'publishing' do
    it 'sends the user to the batch status page like on the catalog' do
      within(:xpath, "//div[contains(@class, 'tufts-buttons')]") do
        click_on 'Publish'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'unpublishing' do
    it 'sends the user to the batch status page like on the catalog' do
      within(:xpath, "//div[contains(@class, 'tufts-buttons')]") do
        click_on 'Unpublish'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'exporting metadata' do
    it 'sends the user to the batch status page like on the catalog' do
      within(:xpath, "//div[contains(@class, 'tufts-buttons')]") do
        click_on 'Export Metadata'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'applying template' do
    it 'sends the user to the batch status page like on the catalog' do
      within(:xpath, "//div[contains(@class, 'tufts-buttons')]") do
        click_on 'Apply Template'
      end
      expect(page).to have_content('Template Behavior')
    end
  end
end
