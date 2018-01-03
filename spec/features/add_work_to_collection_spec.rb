require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Add a work to a collection', :clean, js: true do
  context 'as logged in admin user' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:work) { FactoryGirl.actor_create(:image, user: admin, displays_in: ['dl']) }
    let(:collection) { FactoryGirl.create(:collection) }

    before { login_as admin }

    scenario do
      collection
      expect(work.member_of_collections).to be_empty
      visit("/concern/images/#{work.id}/edit#relationships")
      expect(page).to have_content("This Work in Collections")
      find('select#image_member_of_collection_ids').select(collection.title.first)
      find('input#with_files_submit').click
      expect(page).to have_content collection.title.first
      work.reload
      expect(work.member_of_collections.first.id).to eq(collection.id)
    end
  end
end
