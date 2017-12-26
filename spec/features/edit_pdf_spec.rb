require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Edit a PDF', js: true do
  context 'an admin user' do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login_as admin }

    let(:pdf) do
      FactoryGirl.create(
        :pdf,
        creator: ['creator A', 'creator B'],
        description: ['desc A', 'desc B', 'desc C']
      )
    end

    scenario 'edits a PDF record' do
      visit edit_hyrax_pdf_path(pdf.id)

      # Check existing values when the form loads:
      # The description fields should be in order
      # (plus one blank field)
      expect(all('textarea.pdf_description').map(&:value)).to eq ['desc A', 'desc B', 'desc C', '']
      # The creators should be in order
      expect(all('input.pdf_creator').map(&:value)).to eq ['creator A', 'creator B', '']

      # Edit the description fields:
      all('.pdf_description li').each_with_index do |field, i|
        field.fill_in name: 'pdf[description][]', with: "desc #{i}"
      end

      # Edit the creator fields:
      all('.pdf_creator li').each_with_index do |field, i|
        field.fill_in name: 'pdf[creator][]', with: "creator #{i}"
      end

      click_on 'Save'

      # Now we're on the show page for the PDF.
      # The descriptions should be in correct order.
      expect(page).to have_content 'desc 0 desc 1 desc 2 desc 3'
      # Creators should be in correct order
      expect(page).to have_content 'creator 0 creator 1 creator 2'
    end
  end
end
