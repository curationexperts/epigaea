require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Apply a Template', :clean, js: true do
  let(:object)   { build(:pdf) }
  let(:template) { create(:template) }

  after { template.delete }

  context 'with logged in user' do
    let(:user_attributes) { { email: 'test@example.com' } }

    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      template # create the template

      object.visibility = 'open'
      object.save!
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

    scenario 'apply to a single object' do
      visit "/concern/pdfs/#{object.id}"
      click_link 'Apply Template'

      select template.name
      choose(option: TemplateUpdate::OVERWRITE)

      click_button 'Apply Template'
      expect(page).to have_content template.name
    end
  end
end
