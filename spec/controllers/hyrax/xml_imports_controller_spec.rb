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
    let(:file_ids) { ['38', '91', '1234'] }
    let(:params)   { { id: import.id, uploaded_files: file_ids } }

    it 'adds uploaded files to the import' do
      import.uploaded_file_ids = ['1']

      expect { patch :update, params: params }
        .to change { import.reload.uploaded_file_ids }
    end
  end
end
