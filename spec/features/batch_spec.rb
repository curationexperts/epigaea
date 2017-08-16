require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Apply a Template', :clean, js: true do
  let(:objects) { [object, other] }
  let(:object)  { build(:pdf) }
  let(:other)   { build(:pdf) }
  let(:user)    { create(:admin) }

  before do
    AdminSet.find_or_create_default_admin_set_id

    objects.each do |obj|
      obj.visibility = 'open'
      obj.save!
    end

    login_as user
  end

  scenario 'select items for batch' do
    visit '/catalog'

    find("#document_#{object.id}").check "batch_document_#{object.id}"
  end
end
