require 'rails_helper'

RSpec.describe Hyrax::MetadataExportsController, type: :controller do
  let(:ids)    { models.map(&:id) }
  let(:models) { FactoryGirl.create_list(:generic_object, 2) }

  context 'as admin' do
    let(:user) { FactoryGirl.create(:admin) }

    before { sign_in user }

    describe 'POST #create' do
      let(:params) { { batch_document_ids: ids } }

      it 'creates a batch' do
        expect { post :create, params: params }.to change { Batch.count }.by(1)
      end

      it 'enqueues an export job' do
        ActiveJob::Base.queue_adapter = :test

        expect { post :create, params: params }
          .to enqueue_job(MetadataExportJob)
          .once
      end
    end

    describe 'GET #download' do
      subject(:export) { FactoryGirl.create(:metadata_export) }
      let(:params)     { { id: export.id } }

      it 'returns 404' do
        expect { get :download, params: params }.to raise_error('Not Found')
      end

      context 'with a filename' do
        subject(:export) do
          FactoryGirl.create(:metadata_export, filename: filename)
        end

        let(:contents) { 'moomin moomin' }
        let(:filename) { 'moomin.xml' }

        before { File.open(export.path, 'w') { |f| f.write(contents) } }
        after  { File.delete(export.path) }

        it 'downloads the file' do
          get :download, params: params

          expect(response.body).to eq contents
        end
      end
    end
  end
end
