require 'rails_helper'

RSpec.describe Hyrax::PdfsController, type: :controller do
  let(:work) { FactoryGirl.create(:pdf) }
  let(:user) { FactoryGirl.create(:admin) }
  before do
    sign_in user
    work.title = ["test"]
    work.save_draft
  end
  describe 'PATCH #update' do
    it "deletes the draft when updating" do
      post :update, params: { id: work.id, pdf: { title: 'new_title', description: 'test' } }
      expect(work.draft_saved?).to eq(false)
    end
  end
end
