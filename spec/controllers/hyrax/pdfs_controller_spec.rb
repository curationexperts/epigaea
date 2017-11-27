require 'rails_helper'

RSpec.describe Hyrax::PdfsController, type: :controller do
  render_views
  let(:work) { FactoryGirl.create(:pdf) }
  let(:user) { FactoryGirl.create(:admin) }
  before do
    sign_in user
    work.title = ["a_drafted_title"]
    work.save_draft
  end
  describe 'GET #edit' do
    it 'applies a draft if one exists' do
      get :edit, params: { id: work.id }
      expect(response.body.match('a_drafted_title')).not_to be_nil
    end
    it 'does not display draft data if the draft has been deleted' do
      work.delete_draft
      get :edit, params: { id: work.id }
      expect(response.body.match('a_drafted_title')).to be_nil
    end
  end
  describe 'PATCH #update' do
    it "deletes the draft when updating" do
      post :update, params: { id: work.id, pdf: { title: 'new_title', description: 'test' } }
      expect(work.draft_saved?).to eq(false)
    end
  end
end
