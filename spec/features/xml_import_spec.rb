require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create an XML Import', :clean, js: true do
  let(:document) { file_fixture('pdf-sample.pdf') }
  let(:file)     { file_fixture('mira_xml.xml') }
  let(:user)     { create(:admin) }

  before { login_as user }

  scenario 'import records through a form upload' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', file
    click_button 'Next'

    within(:css, 'div.alert-warning') do
      expect(page).to have_css('li.missing-file', count: 2)
      expect(page).to have_content 'pdf-sample.pdf'
      expect(page).to have_content '2.pdf'
    end

    click_link 'add additional files to this batch'

    # We don't directly test the Hyrax file upload behavior, so no files are
    # attached here.

    click_button 'Add Files to Batch'

    expect(page).to have_content 'pdf-sample.pdf'
    expect(page).to have_content '2.pdf'
  end

  scenario 'importing an invalid file' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', file_fixture('mira_xml_invalid.xml')

    click_button 'Next'

    expect(page).to have_content 'Error'
  end
end
