require 'rails_helper'

RSpec.describe Hyrax::TemplateUpdatesController, type: :controller do
  let(:ids)   { [model.id] }
  let(:model) { FactoryGirl.create(:generic_object) }

  context 'as admin' do
    let(:user) { FactoryGirl.create(:admin) }

    before { sign_in user }

    describe 'GET #new' do
      it 'renders the form' do
        get :new
        expect(response).to render_template :new
      end

      it 'assigns update' do
        get :new
        expect(assigns(:update)).to be_a_new(TemplateUpdate)
      end

      it 'assigns update with ids' do
        get :new, params: { ids: ids }

        expect(assigns(:update))
          .to have_attributes(ids: a_collection_containing_exactly(*ids))
      end

      it 'assigns update with batch_document_ids' do
        get :new, params: { batch_document_ids: ids }

        expect(assigns(:update))
          .to have_attributes(ids: a_collection_containing_exactly(*ids))
      end
    end

    describe 'POST #create' do
      let(:update) { FactoryGirl.build(:template_update) }

      it 'enqueues jobs' do
        ActiveJob::Base.queue_adapter = :test

        expect { post :create, params: { template_update: update.attributes } }
          .to enqueue_job(TemplateUpdateJob)
          .exactly(:twice)
      end
    end
  end
end
