require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create and revert a draft', :clean, js: true do
  context 'a logged in admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:pdf) { FactoryGirl.build(:pdf) }

    # @todo add support for file creation to actor_create build strategy
    before do
      login_as user
      pdf_file = File.open(Rails.root.join('spec', 'fixtures', 'hello.pdf'))
      current_ability = ::Ability.new(user)
      uploaded_file = Hyrax::UploadedFile.create(user: user, file: pdf_file)
      attributes = { uploaded_files: [uploaded_file.id] }
      env = Hyrax::Actors::Environment.new(pdf, current_ability, attributes)
      Hyrax::CurationConcern.actor.create(env)
    end

    scenario do
      visit "/concern/pdfs/#{pdf.id}"
      click_on 'Publish'
      expect(page).to have_content('Published')
      click_on 'Edit'
      expect(page).to have_content('Describe')
      click_on 'Save Draft'
      expect(page).to have_content('Edited')
      click_on 'Revert Draft'
      expect(page).to have_content('Published')
    end
  end
end
