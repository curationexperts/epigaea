# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'batch', type: :feature, js: true do
  let(:current_user) { create(:admin) }
  let(:work_first) { create(:populated_pdf) }
  let(:work_second) { create(:populated_pdf) }

  before do
    login_as current_user
    visit '/dashboard/works'
    work_first.save!
    work_second.save!
    check 'check_all'
    optional "Sometimes fails" if ENV['TRAVIS']
  end

  describe 'publishing' do
    it 'has tufts-buttons on the page' do
      optional "Sometimes fails" if ENV['TRAVIS']
      expect(page).to have_selector('.tufts-buttons')
    end

    it 'sends the user to the batch status page like on the catalog' do
      optional "Sometimes fails" if ENV['TRAVIS']
      expect(page).to have_selector('.tufts-buttons')
      within('.tufts-buttons') do
        click_on 'Publish'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'unpublishing' do
    it 'sends the user to the batch status page like on the catalog' do
      optional "Sometimes fails" if ENV['TRAVIS']
      expect(page).to have_selector('.tufts-buttons')
      within('.tufts-buttons') do
        click_on 'Unpublish'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'exporting metadata' do
    it 'sends the user to the batch status page like on the catalog' do
      optional "Sometimes fails" if ENV['TRAVIS']
      expect(page).to have_selector('.tufts-buttons')
      within('.tufts-buttons') do
        click_on 'Export Metadata'
      end
      expect(page).to have_content('Batch Status')
    end
  end

  describe 'applying template' do
    it 'sends the user to the batch status page like on the catalog' do
      optional "Sometimes fails" if ENV['TRAVIS']
      expect(page).to have_selector('.tufts-buttons')
      within('.tufts-buttons') do
        click_on 'Apply Template'
      end

      expect(page).to have_content('Template Behavior')
    end
  end
end
