require 'rails_helper'

# rubocop:disable RSpec/NestedGroups
RSpec.describe Hyrax::XmlImportsController, type: :controller do
  let(:import) { FactoryGirl.create(:xml_import) }

  context 'as admin' do
    include_context 'as admin'

    describe 'GET #new' do
      it 'renders the form' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      let(:file_upload) { fixture_file_upload('files/mira_xml.xml') }

      it 'uploads the file' do
        post :create, params: { xml_import: { metadata_file: file_upload } }
        expect(assigns(:import).metadata_file.filename).to eq 'mira_xml.xml'
      end

      it 'creates a batch' do
        post :create, params: { xml_import: { metadata_file: file_upload } }
        expect(assigns(:import).batch.creator).to eq user
      end

      context 'when the file has an error' do
        let(:file_upload) { fixture_file_upload('files/mira_xml_invalid.xml') }

        it 'flashes an alert' do
          post :create, params: { xml_import: { metadata_file: file_upload } }
          expect(flash[:alert]).to be_present
        end
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the import' do
      get :edit, params: { id: import.id }

      expect(assigns(:import).xml_import).to eq import
    end
  end

  describe 'GET #show' do
    it 'renders the correct import details' do
      get :show, params: { id: import.id }

      expect(assigns(:import).xml_import).to eq import
    end

    it 'renders the batch' do
      get :show, params: { id: import.id }

      expect(assigns(:import).batch_presenter.object).to eq import.batch
    end
  end

  describe 'PATCH #update' do
    let(:params) { { id: import.id, uploaded_files: file_ids } }

    context 'when files cannot be found' do
      let(:file_ids) { ['38', '91', '1234'] }

      it 'raises an error when files cannot be found' do
        import.uploaded_file_ids = ['1']

        expect { patch :update, params: params }
          .to raise_error { ActiveRecord::RecordInvalid }
      end
    end

    context 'with no files' do
      let(:file_ids) { [] }

      it 'alerts that no files are provided' do
        patch :update, params: params

        expect(flash[:alert]).to be_present
      end
    end

    context 'when files match metadata' do
      let(:file_ids) { uploads.map(&:id) }
      let(:uploads)  { [FactoryGirl.create(:hyrax_uploaded_file)] }

      before { ActiveJob::Base.queue_adapter = :test }

      it 'enqueues jobs for the matching file' do
        expect { patch :update, params: params }
          .to enqueue_job(ImportJob)
          .with(import, uploads.first)
          .exactly(:once)
      end

      it 'updates file ids' do
        expect { patch :update, params: params }
          .to change { import.reload.uploaded_file_ids }
          .to contain_exactly(*file_ids.map(&:to_s))
      end
    end
  end
end
