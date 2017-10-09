require 'rails_helper'

RSpec.describe Tufts::PublicationStatusController, :workflow, type: :controller do
  let(:work) { FactoryGirl.create(:pdf) }
  let(:depositing_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  before do
    allow(CharacterizeJob).to receive(:perform_later) # There is no fits installed on travis-ci
    current_ability = ::Ability.new(depositing_user)
    attributes = {}
    env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
    Hyrax::CurationConcern.actor.create(env)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  after do
    work.destroy
  end

  describe 'POST #publish' do
    it 'sets the workflow status to published' do
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
      post :publish, params: { "id" => work.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["published"]).to eq(true)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"
    end
    it 'sets the workflow status to unpublished' do
      post :publish, params: { "id" => work.id }
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"
      post :unpublish, params: { "id" => work.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["unpublished"]).to eq(true)
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
    end
    it "gets the workflow status" do
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
      post :status, params: { "id" => work.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["status"]).to eq("unpublished")
      post :publish, params: { "id" => work.id }
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"
      post :status, params: { "id" => work.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["status"]).to eq("published")
    end
  end
end
