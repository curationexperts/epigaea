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

    objects.each do |obj|
      find("#document_#{obj.id}").check "batch_document_#{obj.id}"
    end

    click_on 'Apply Template'

    expect(page).to have_content 'Template Behavior'
  end

  scenario 'select all' do
    visit '/catalog'
    check 'check_all'

    expect(find('#selected_documents_count')).to have_content objects.count
  end
end

RSpec.feature 'Manage batches', :clean, js: true do
  let(:batch)  { create(:batch, ids: [pdf.id]) }
  let(:user)   { create(:admin) }
  let(:pdf)    { create(:pdf) }

  before do
    login_as user
    batch
  end

  scenario 'list batches' do
    visit '/batches'

    expect(page).to have_content batch.creator
  end

  scenario 'show batch' do
    visit "/batches/#{batch.id}"

    expect(page).to have_content batch.creator
  end
end
