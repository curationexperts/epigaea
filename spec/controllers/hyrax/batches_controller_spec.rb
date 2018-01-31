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

    describe 'POST #create' do
      let(:ids) { ['abc', '123'] }

      let(:params) do
        {
          batch: {
            ids: ids,
            batchable_attributes: {
              batch_type: 'Publish'
            }
          }
        }
      end

      it 'creates a batch' do
        expect { post :create, params: params }.to change { Batch.count }.by(1)
      end

      it 'assigns the current user to the batch' do
        post :create, params: params
        expect(Batch.last.user).to be_a User
      end

      it 'enqueues jobs' do
        ActiveJob::Base.queue_adapter = :test

        expect { post :create, params: params }
          .to enqueue_job(PublishJob)
          .exactly(:twice)
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
