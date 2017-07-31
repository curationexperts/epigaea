require 'rails_helper'
require 'import_export/deposit_type_exporter'

describe DepositTypesController do
  let(:dt) { FactoryGirl.create(:deposit_type, display_name: 'DT') }

  before do
    DepositType.destroy_all
  end

  context 'a non-admin user' do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    def assert_access_denied(http_command, action, opts = {})
      send(http_command, action, opts)
      flash[:alert].should =~ /You are not authorized/
      response.should redirect_to(root_url)
    end

    it 'denies access', :no_ci do
      pending('waiting for login')
      assert_access_denied :get, :index
      assert_access_denied :get, :export
      assert_access_denied :get, :new
      assert_access_denied :post, :create, deposit_type: dt.attributes
      assert_access_denied :get, :show, id: dt.id
      assert_access_denied :delete, :destroy, id: dt.id
      assert_access_denied :put, :update, id: dt.id
      # Edit is tested below, since it has different behavior
    end

    it 'denies access to edit deposit types', :no_ci do
      pending('waiting for login')
      get :edit, params: { id: dt.id }
      flash[:alert].should =~ /You do not have sufficient privilege/
      response.should redirect_to(contributions_path)
    end
  end

  context 'an admin user' do
    # TODO: switch this over to a real admin user
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe 'get index' do
      it 'succeeds', :no_ci do
        get :index
        response.should be_successful
        response.should render_template(:index)
        assigns(:deposit_types).should eq([dt])
      end
    end

    describe 'get export' do
      it 'succeeds', :no_ci do
        DepositTypeExporter.any_instance.should_receive(:export_to_csv)
        get :export
        response.should redirect_to(deposit_types_path)
        flash[:notice].should =~ /exported the deposit types to: #{File.join(DepositTypeExporter::DEFAULT_EXPORT_DIR)}/
      end
    end

    describe 'get new' do
      it 'succeeds', :no_ci do
        get :new
        assigns(:deposit_type).should_not be_nil
        response.should render_template(:new)
      end
    end

    describe 'get show' do
      it 'succeeds', :no_ci do
        get :show, params: { id: dt.id }
        response.should be_successful
        response.should render_template(:show)
        assigns(:deposit_type).should eq(dt)
      end
    end

    describe 'destroy' do
      it 'succeeds', :no_ci do
        pending('waiting for login')
        get :edit, params: { id: dt.id }
        flash[:alert].should =~ /You do not have sufficient privilege/
        response.should redirect_to(contributions_path)
      end
    end

    context 'an admin user' do
      # TODO: switch this over to a real admin user
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe 'get index' do
        it 'succeeds', :no_ci do
          get :index
          response.should be_successful
          response.should render_template(:index)
          assigns(:deposit_types).should eq([dt])
        end
      end

      describe 'get export' do
        it 'succeeds', :no_ci do
          DepositTypeExporter.any_instance.should_receive(:export_to_csv)
          get :export
          response.should redirect_to(deposit_types_path)
          flash[:notice].should =~ /exported the deposit types to: #{File.join(DepositTypeExporter::DEFAULT_EXPORT_DIR)}/
        end
      end

      describe 'get new' do
        it 'succeeds', :no_ci do
          get :new
          assigns(:deposit_type).should_not be_nil
          response.should render_template(:new)
        end
      end

      describe 'get show' do
        it 'succeeds', :no_ci do
          get :show, params: { id: dt.id }
          response.should be_successful
          response.should render_template(:show)
          assigns(:deposit_type).should eq(dt)
        end
      end

      describe 'destroy' do
        it 'succeeds', :no_ci do
          dt2 = FactoryGirl.create(:deposit_type, display_name: 'other type')
          delete :destroy, params: { id: dt2.id }
          DepositType.count.should eq(0)
        end
      end

      describe 'create' do
        it 'succeeds', :no_ci do
          post :create, params: { deposit_type: FactoryGirl.attributes_for(:deposit_type, display_name: 'New Type', deposit_view: 'generic_deposit') }
          DepositType.count.should eq(1)
          new_type = DepositType.where(display_name: 'New Type').first
          response.should redirect_to(deposit_type_path(new_type))
          assigns(:deposit_type).should eq(new_type)
        end
      end

      describe 'create with bad inputs' do
        it 'renders the form', :no_ci do
          # Make it fail to validate:
          DepositType.any_instance.stub(:valid?).and_return(false)
          post :create, params: { deposit_type: { display_name: 'New Type' } }
          response.should render_template(:new)
          DepositType.count.should eq(0)
          assigns(:deposit_type).should_not be_nil
        end
      end

      describe 'edit' do
        it 'succeeds', :no_ci do
          get :edit, params: { id: dt.id }
          assigns(:deposit_type).should eq(dt)
          response.should render_template(:edit)
        end
      end

      describe 'update' do
        it 'succeeds', :no_ci do
          dt.display_name.should eq('DT')
          put :update, params: { id: dt.id, deposit_type: { display_name: 'New Name' } }
          dt.reload
          dt.display_name.should eq('New Name')
          assigns(:deposit_type).should eq(dt)
          response.should redirect_to(deposit_type_path(dt))
        end
      end

      describe 'update with bad inputs' do
        it 'renders the form', :no_ci do
          pending 'not sure why this is failing'
          # Make it fail to validate:
          DepositType.any_instance.stub(:valid?).and_return(false)
          dt.display_name.should eq('DT')

          put :update, params: { id: dt.id, deposit_type: { display_name: 'New Name' } }
          dt.reload
          dt.display_name.should eq('DT')
          assigns(:deposit_type).should eq(dt)
          response.should render_template(:edit)
        end
      end
    end
  end
end
