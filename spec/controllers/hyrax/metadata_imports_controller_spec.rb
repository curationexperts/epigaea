require 'rails_helper'

RSpec.describe Hyrax::MetadataImportsController, type: :controller do
  let(:import) { FactoryGirl.create(:metadata_import) }
  let(:mira_export_ids) { ['7s75dc36z', 'wm117n96b', 'pk02c9724', 'xs55mc046', 'j67313767'] }
  context 'as admin' do
    include_context 'as admin'

    describe 'GET #new' do
      it 'renders the form' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      let(:file_upload) { fixture_file_upload('files/mira_export.xml') }
      let(:params)      { { metadata_import: { metadata_file: file_upload } } }

      before do
        ActiveJob::Base.queue_adapter = :test
        # All of the files we are updating must exist before the metadata import object can be created
        mira_export_ids.each do |id|
          FactoryGirl.create(:pdf, id: id)
        end
      end

      it 'enqueues jobs for items in file' do
        expect { post :create, params: params }
          .to enqueue_job(MetadataImportJob)
          .exactly(5).times
      end
    end
  end
end
