require 'rails_helper'

RSpec.describe Tufts::QrStatusController, type: :controller do
  let(:model) { FactoryGirl.build(:pdf) }

  before { model.save }

  after do
    model.destroy
  end

  describe 'POST #set_status' do
    it 'sets qr_status to batch reviewed' do
      post :set_status, params: { "id" => model.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["batch_reviewed"]).to eq(true)
    end
  end
  describe 'GET #status when you have batch reviwed status' do
    it 'returns true if the status is batch reviewed' do
      model.qr_status = ['Batch Reviewed']
      model.save
      get :status, params: { "id" => model.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["batch_reviewed"]).to eq(true)
    end
  end
  describe 'GET #status when you don\'t have batch reviwed status' do
    it 'returns false if the status is not batch reviewed' do
      get :status, params: { "id" => model.id }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["batch_reviewed"]).to eq(false)
    end
  end
end
