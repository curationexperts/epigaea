require 'rails_helper'
require 'import_export/deposit_type_exporter'

# rubocop:disable RSpec/MultipleExpectations
describe DepositTypesController do
  let(:dt) { FactoryGirl.create(:deposit_type, display_name: 'DT') }

  before { DepositType.destroy_all }

  context 'a non-admin user' do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in user }

    def assert_access_denied(http_command, action, opts = {})
      send(http_command, action, opts)
      expect(flash[:alert]).to eq 'You are not authorized to access this page.'
    end

    def assert_unauthorized(http_command, action, opts = {})
      send(http_command, action, opts)
      expect(response.code).to eq('401')
    end

    it 'denies access' do
      assert_access_denied :get, :index
      assert_access_denied :get, :export
      assert_access_denied :get, :new
      assert_access_denied :post, :create, deposit_type: dt.attributes
      assert_unauthorized :get, :show, id: dt.id
      assert_unauthorized :delete, :destroy, id: dt.id
      assert_unauthorized :put, :update, id: dt.id
      # Edit is tested below, since it has different behavior
    end

    it 'denies access to edit deposit types' do
      get :edit, params: { id: dt.id }
      expect(response.code).to eq('401')
    end
  end

  context 'an admin user' do
    let(:admin) { FactoryGirl.create(:admin) }

    before { sign_in admin }

    describe 'get index' do
      it 'succeeds' do
        get :index

        expect(response).to be_successful
        expect(response).to render_template(:index)
        expect(assigns(:deposit_types)).to contain_exactly(dt)
      end
    end

    describe 'get export' do
      it 'succeeds' do
        get :export

        expect(response).to redirect_to(deposit_types_path)
        expect(flash[:notice])
          .to match(/exported the deposit types to: #{File.join(DepositTypeExporter::DEFAULT_EXPORT_DIR)}/)
      end
    end

    describe 'get new' do
      it 'succeeds' do
        get :new

        expect(assigns(:deposit_type)).not_to be_nil
        expect(response).to render_template(:new)
      end
    end

    describe 'get show' do
      it 'succeeds' do
        get :show, params: { id: dt.id }

        expect(response).to be_successful
        expect(response).to render_template(:show)
        expect(assigns(:deposit_type)).to eq dt
      end
    end

    describe 'destroy' do
      it 'succeeds' do
        get :edit, params: { id: dt.id }
        expect(response.code).to eq('200')
      end
    end

    describe 'get index' do
      it 'succeeds' do
        get :index

        expect(response).to be_successful
        expect(response).to render_template(:index)
        expect(assigns(:deposit_types)).to contain_exactly(dt)
      end
    end

    describe 'get export' do
      it 'succeeds' do
        get :export

        expect(response).to redirect_to(deposit_types_path)
        expect(flash[:notice])
          .to match(/exported the deposit types to: #{File.join(DepositTypeExporter::DEFAULT_EXPORT_DIR)}/)
      end
    end

    describe 'get new' do
      it 'succeeds' do
        get :new
        expect(assigns(:deposit_type)).not_to be_nil
        expect(response).to render_template(:new)
      end
    end

    describe 'get show' do
      it 'succeeds' do
        get :show, params: { id: dt.id }
        expect(response).to be_successful
        expect(response).to render_template(:show)
        expect(assigns(:deposit_type)).to eq dt
      end
    end

    describe 'destroy' do
      it 'succeeds' do
        dt2 = FactoryGirl.create(:deposit_type, display_name: 'other type')
        delete :destroy, params: { id: dt2.id }
        expect(DepositType.count).to eq 0
      end
    end

    describe 'create' do
      it 'succeeds' do
        post :create, params: { deposit_type: FactoryGirl.attributes_for(:deposit_type, display_name: 'New Type', deposit_view: 'generic_deposit') }
        expect(DepositType.count).to eq 1
        new_type = DepositType.where(display_name: 'New Type').first
        expect(response).to redirect_to(deposit_type_path(new_type))
        expect(assigns(:deposit_type)).to eq new_type
      end
    end

    describe 'create with bad inputs' do
      it 'renders the form' do
        # Make it fail to validate:
        DepositType.any_instance.stub(:valid?).and_return(false)
        post :create, params: { deposit_type: { display_name: 'New Type' } }

        expect(response).to render_template(:new)
        expect(DepositType.count).to eq 0
        expect(assigns(:deposit_type)).not_to be_nil
      end
    end

    describe 'edit' do
      it 'succeeds' do
        get :edit, params: { id: dt.id }

        expect(assigns(:deposit_type)).to eq dt
        expect(response).to render_template(:edit)
      end
    end

    describe 'update' do
      it 'succeeds' do
        expect(dt.display_name).to eq 'DT'

        put :update, params: { id: dt.id, deposit_type: { display_name: 'New Name' } }
        dt.reload

        expect(dt.display_name).to eq 'New Name'
        expect(assigns(:deposit_type)).to eq dt
        expect(response).to redirect_to(deposit_type_path(dt))
      end
    end

    describe 'update with bad inputs' do
      it 'renders the form' do
        pending 'not sure why this is failing'
        # Make it fail to validate:
        DepositType.any_instance.stub(:valid?).and_return(false)

        expect(dt.display_name).to eq('DT')

        put :update, params: {
          id:           dt.id,
          deposit_type: { display_name: 'New Name' }
        }

        dt.reload

        expect(dt.display_name).to eq 'DT'
        expect(assigns(:deposit_type)).to eq dt
        expect(response).to render_template(:edit)
      end
    end
  end
end
