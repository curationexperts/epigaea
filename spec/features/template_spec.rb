require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Apply a Template', :clean, js: true do
  let(:object)    { create(:pdf) }
  let!(:template) { create(:template) }

  after { Tufts::Template.all.each(&:delete) }

  context 'with logged in user' do
    let(:user) { FactoryGirl.create(:admin) }

    before { login_as user }

    scenario 'apply to a single object' do
      ActiveJob::Base.queue_adapter = :test
      visit "/concern/pdfs/#{object.id}"
      click_link 'Apply Template'

      select template.name
      choose(option: TemplateUpdate::OVERWRITE)

      expect { click_button 'Apply Template' }
        .to enqueue_job(described_class)
        .with(TemplateUpdate::OVERWRITE, object.id, template.name)
    end

    scenario 'apply to a single object with preserve' do
      ActiveJob::Base.queue_adapter = :test
      visit "/concern/pdfs/#{object.id}"
      click_link 'Apply Template'

      select template.name
      choose(option: TemplateUpdate::PRESERVE)

      expect { click_button 'Apply Template' }
        .to enqueue_job(described_class)
        .with(TemplateUpdate::PRESERVE, object.id, template.name)
    end

    scenario 'view templates' do
      visit '/templates'
      expect(page).to have_content template.name
    end

    scenario 'create a template' do
      visit '/templates'
      first(:link, 'New Template').click

      fill_in 'Template name', with: 'Moomin Template'
      fill_in 'Title', with: 'Moomin Title'

      click_button 'Save'
      expect(page).to have_content 'Moomin Template'
    end

    scenario 'delete a template' do
      visit '/templates'
      click_link 'Delete'

      expect(page).not_to have_content template.name
    end

    scenario 'edit a template' do
      visit '/templates'

      click_link 'Edit', id: "edit-#{template.name}"

      fill_in 'Title', with: 'Moomin Title'
      click_button 'Save'

      expect(Tufts::Template.for(name: template.name).changeset)
        .not_to be_empty

      # Reload the form: the values I previously entered should be there
      click_link 'Edit', id: "edit-#{template.name}"
      expect(find_field('Title').value).to eq 'Moomin Title'
    end

    scenario 'edit a template name' do
      visit "/templates/#{URI.encode(template.name)}/edit"

      fill_in 'Template name', with: 'Moomin Template'
      click_button 'Save'

      expect(template.name).to eq 'Moomin Template'
    end
  end
end
