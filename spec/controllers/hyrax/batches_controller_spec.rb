require 'rails_helper'

RSpec.describe Hyrax::BatchesController, type: :controller do
  let(:batch) { FactoryGirl.create(:batch) }

  context 'as admin' do
    include_context 'as admin'

    describe 'GET #index' do
      before { batch }

      it 'assigns @batches' do
        get :index

        expect(assigns(:batches).map(&:object)).to contain_exactly(batch)
      end
    end

    describe 'GET #show' do
      let(:batch) { FactoryGirl.create(:batch) }

      it 'assigns @batch' do
        get :show, params: { id: batch.id }

        expect(assigns(:batch).object).to eq batch
      end
    end
  end
end
