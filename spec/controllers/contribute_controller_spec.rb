require 'rails_helper'

describe ContributeController do
  describe "for a not-signed in user" do
    describe "new" do
      it "redirects to sign in", :no_ci do
        get :new
        response.should redirect_to new_user_session_path(locale: :en)
      end
    end
    describe "create" do
      it "redirects to sign in", :no_ci do
        post :create
        response.should redirect_to new_user_session_path(locale: :en)
      end
    end
  end

  describe "for a signed in user" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe "GET '/'" do
      it "returns http success", :no_ci do
        get :index
        response.should be_success
      end
    end

    describe "GET 'license'" do
      it "returns http success", :no_ci do
        get 'license'
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "redirects to contribute home when no deposit type is specified", :no_ci do
        get 'new'
        response.should redirect_to contributions_path
      end

      describe 'with valid deposit_type' do
        let(:deposit_type) { FactoryGirl.create(:deposit_type, display_name: 'Test Option', deposit_view: 'generic_deposit') }
        before :all do
          DepositType.delete_all
        end

        render_views

        it 'renders the correct template', :no_ci do
          get 'new', params: { deposit_type: deposit_type.id }
          response.should render_template('contribute/deposit_view/_generic_deposit')
        end

        it 'includes deposit license text', :no_ci do
          get 'new', params: { deposit_type: deposit_type.id }
          response.body.should have_content deposit_type.deposit_agreement
        end

        it 'sets deposit_type and contribution', :no_ci do
          get :new, params: { deposit_type: deposit_type }
          assigns(:deposit_type).should eq(deposit_type)
          assigns(:contribution).should_not be_nil
        end
      end
    end

    describe "GET 'redirect'" do
      it "redirects to contribute", :no_ci do
        get 'redirect'
        response.should redirect_to contributions_path
      end
    end

    describe "POST 'create'" do
      it "redirects when no deposit type is specified", :no_ci do
        post :create, params: { contribution: { title: 'Sample', description: 'Description', creator: user.display_name } }
        response.should redirect_to contributions_path
      end

      describe 'with valid deposit_type' do
        before { Pdf.destroy_all }
        let(:deposit_type) { FactoryGirl.create(:deposit_type) }
        let(:file) { fixture_file_upload('/local_object_store/data01/tufts/central/dca/MISS/archival_pdf/MISS.ISS.IPPI.archival.pdf', 'application/pdf') }

        it 'succeeds and stores file attachments', :no_ci do
          expect do
            post :create, params: { contribution: { title: 'Sample', description: 'Description goes here',
                                                    creator: user.display_name, attachment: file }, deposit_type: deposit_type }

            response.should redirect_to contributions_path
            flash[:notice].should eq('Your file has been saved!')
            assigns(:deposit_type).should eq(deposit_type)
            contribution = Pdf.find(assigns[:contribution].id)
            contribution.datastreams['Archival.pdf'].dsLocation.should_not be_nil
            contribution.datastreams['Archival.pdf'].mimeType.should eq('application/pdf')
            contribution.license.should eq([deposit_type.license_name])
          end.to change { Pdf.count }.by(1)
        end

        it 'automaticallies populate static fields', :no_ci do
          post :create, params: { contribution: { title: 'Sample', description: 'User supplied brief description',
                                                  creator: 'John Doe', attachment: file }, deposit_type: deposit_type }

          contribution = Pdf.find(assigns[:contribution].id)
          expect(contribution.steward).to eq ['dca']
          expect(contribution.displays).to eq ['dl']
          expect(contribution.publisher).to eq ['Tufts University. Digital Collections and Archives.']
          expect(contribution.rights).to eq ['http://dca.tufts.edu/ua/access/rights-creator.html']
          expect(contribution.format).to eq ['application/pdf']
        end

        it "lists deposit_method as self deposit", :no_ci do
          now = Time.zone.now
          Time.stub(:now).and_return(now)
          post :create, params: { contribution: { title: 'Sample', description: 'Description of goes here',
                                                  creator: 'Mickey Mouse', attachment: file }, deposit_type: deposit_type }
          contribution = Pdf.find(assigns[:contribution].id)
          expect(contribution.note.first).to eq "Mickey Mouse self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
          expect(contribution.date_available).to eq [now.to_s]
          expect(contribution.date_submitted).to eq [now.to_s]
          expect(contribution.createdby).to eq Contribution::SELFDEP
        end

        it 'requires a file attachments', :no_ci do
          post :create, params: { contribution: { title: 'Sample', description: 'Description of uploaded file goes here', creator: user.display_name }, deposit_type: deposit_type }
          response.should render_template('new')
        end
      end
    end
  end
end
