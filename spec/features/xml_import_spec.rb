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
      expect(page).to have_css('li.missing-file', count: 3)
      expect(page).to have_content 'pdf-sample.pdf'
      expect(page).to have_content '2.pdf'
      expect(page).to have_content '3.pdf'
    end

    click_link 'add additional files to this batch'

    # We don't directly test the Hyrax file upload behavior, so no files are
    # attached here.

    click_button 'Add Files to Batch'

    expect(page).to have_content 'pdf-sample.pdf'
    expect(page).to have_content '2.pdf'
    expect(page).to have_content '3.pdf'
  end

  scenario 'importing an invalid file' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', file_fixture('mira_xml_invalid.xml')

    click_button 'Next'

    expect(page).to have_content 'Error'
  end

  scenario 'importing a malformed file' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', File.join(fixture_path, 'files', 'malformed_files', 'stray_element.xml')

    click_button 'Next'
    expect(page).to have_content 'Error'
    expect(page).to have_content 'Malformed XML'
  end

  scenario 'importing a file with missing required fields' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', File.join(fixture_path, 'files', 'malformed_files', 'missing_required_fields.xml')

    click_button 'Next'
    expect(page).to have_content 'Missing required field: Sonnet_1.pdf is missing tufts:displays_in'
    expect(page).to have_content 'Missing required field: Sonnet_1.pdf is missing dc:title'
    expect(page).to have_content 'Missing required field: Sonnet_1.pdf is missing model:hasModel'
  end

  scenario 'importing a file with missing filename gives line number' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', File.join(fixture_path, 'files', 'malformed_files', 'missing_filename.xml')

    click_button 'Next'
    expect(page).not_to have_content 'Unknown Line'
    expect(page).to have_content "A file was missing for the record at line: 6"
    expect(page).to have_content "A file was missing for the record at line: 27"
  end

  # When we produce lots of errors we've been getting CookieOverflow exceptions
  scenario 'importing a very large file with missing required fields' do
    visit '/xml_imports/new'

    attach_file 'metadata_file', File.join(fixture_path, 'files', 'malformed_files', '100_sample.xml')

    click_button 'Next'
    expect(page).to have_content 'Missing required field'
    expect(page).to have_content "too many to display"
  end
end
