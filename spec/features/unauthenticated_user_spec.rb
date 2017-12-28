require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'unauthenticated users' do
  let(:work) { FactoryGirl.actor_create(:pdf, user: create(:admin)) }
  context 'an unauthenticated user' do
    context 'is redirected to the /contribute page' do
      scenario 'when attempting to access /' do
        visit("/")
        expect(current_path).to eq "/contribute"
      end
      scenario 'when attempting to access a work' do
        visit("/concern/pdfs/#{work.id}")
        expect(current_path).to eq "/contribute"
      end
      scenario 'when attempting to access user profiles' do
        visit("/dashboard/profiles/fake@example-dot-com")
        expect(current_path).to eq "/contribute"
      end
      scenario 'when attempting to access the admin dashboard' do
        visit("/admin/stats")
        expect(current_path).to eq "/contribute"
      end
    end
  end
end
