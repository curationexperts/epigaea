require 'rails_helper'

describe ContributeController do
  let(:deposit_type) { FactoryGirl.create(:deposit_type) }

  describe 'for a not-signed in user' do
    describe 'GET #new' do
      it 'redirects to sign in' do
        get :new
        expect(response).to redirect_to contributions_path
      end
    end

    describe 'POST #create' do
      it 'redirects to sign in' do
        post :create
        expect(response).to redirect_to contributions_path
      end
    end
  end

  describe 'for a signed in user' do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe 'GET #index' do
      it 'returns http success' do
        get :index

        expect(response).to be_success
      end
    end

    describe 'GET #license' do
      it 'returns http success' do
        get 'license'
        expect(response).to be_success
      end
    end

    describe 'GET #new' do
      it 'redirects to contribute home when no deposit type is specified' do
        get 'new'
        expect(response).to redirect_to contributions_path
      end

      describe 'with valid deposit_type' do
        let(:deposit_type) do
          FactoryGirl.create(:deposit_type,
                             display_name: 'Test Option',
                             deposit_view: 'generic_deposit')
        end

        render_views

        it 'renders the correct template' do
          get 'new', params: { deposit_type: deposit_type.id }

          expect(response)
            .to render_template('contribute/deposit_view/_generic_deposit')
        end

        it 'includes deposit license text' do
          get 'new', params: { deposit_type: deposit_type.id }

          expect(response.body)
            .to have_content deposit_type.deposit_agreement
        end

        it 'sets deposit_type and contribution' do
          get :new, params: { deposit_type: deposit_type }

          expect(assigns(:deposit_type)).to eq(deposit_type)
          expect(assigns(:contribution)).not_to be_nil
        end
      end
    end

    describe 'GET #redirect' do
      it 'redirects to contribute' do
        get 'redirect'
        expect(response).to redirect_to contributions_path
      end
    end

    describe 'POST #create' do
      let(:params) do
        { contribution: { title:       'Sample',
                          description: 'Description',
                          creator:     'Someone' } }
      end

      it 'redirects when no deposit type is specified' do
        post :create, params: params

        expect(response).to redirect_to contributions_path
      end

      describe 'with valid deposit_type' do
        before { Pdf.destroy_all }
        let(:uploaded_file) do
          path = 'hello.pdf'
          fixture_file_upload(path, 'application/pdf')
        end

        it 'succeeds and stores file attachments', :workflow do
          post :create, params: { contribution: { title: 'Sample', abstract: 'Description goes here',
                                                  creator: 'Someone', attachment: uploaded_file },
                                  deposit_type: deposit_type.id }
          expect(Pdf.count).to eq(1)
        end

        it 'automaticaly populates static fields', :workflow do
          post :create, params: { contribution: { title: 'Sample', description: 'User supplied brief description',
                                                  creator: 'John Doe', attachment: uploaded_file }, deposit_type: deposit_type.id }

          contribution = Pdf.find(assigns[:contribution].tufts_pdf.id)
          expect(contribution.steward).to eq 'dca'
          expect(contribution.displays_in).to eq ['dl']
          expect(contribution.publisher).to eq ['Tufts University. Digital Collections and Archives.']
          expect(contribution.tufts_license).to eq [deposit_type.license_name]
        end

        it 'lists deposit_method as self deposit', :workflow do
          now = Time.zone.now
          allow(Time.zone).to receive(:now).and_return(now)

          post :create, params: {
            contribution: { title:       'Sample',
                            description: 'Description of goes here',
                            creator:     'Mickey Mouse',
                            attachment:  uploaded_file },
            deposit_type: deposit_type.id
          }

          contribution = Pdf.find(assigns[:contribution].tufts_pdf.id)

          expect(contribution.internal_note).to eq "Mickey Mouse self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
          expect(contribution.date_available).to eq [now.to_s]
          expect(contribution.date_uploaded).to eq now
          expect(contribution.createdby).to eq [Contribution::SELFDEP]
        end

        it 'requires a file attachments' do
          params = { contribution: { title:       'Sample',
                                     description: 'Description of uploaded file goes here',
                                     creator:      user.display_name },
                     deposit_type: deposit_type }

          post :create, params: params

          expect(response).to render_template('new')
        end
      end
    end
  end

  describe 'normalize spaces before passing them to object creation methods' do
    let(:params) do
      {
        "utf8" => "✓",
        "contribution" =>
        {
          "title" => " Space   non normalized  \t title    ",
          "creator" => " Name   with  Spaces ",
          "bibliographic_citation" => " bibliographic   citation   with     spaces    ",
          "embargo_note" => "0",
          "description" => " A short   description \n   with  wonky spaces   \n\n\n\n\n But keep two newlines between paragraphs. ",
          "abstract" => " A short   description \n   with  wonky spaces   \n\n\n\n\n But keep two newlines between paragraphs. "
        },
        "deposit_type" => "1",
        "commit" => "Agree & Deposit",
        "controller" => "contribute",
        "action" => "create"
      }
    end
    it "normalizes the text in the params hash" do
      described_class.new.normalize_whitespace(params)
      expect(params["contribution"]["title"]).to eq "Space non normalized title"
      expect(params["contribution"]["creator"]).to eq "Name with Spaces"
      expect(params["contribution"]["description"]).to eq "A short description \n with wonky spaces\n\nBut keep two newlines between paragraphs."
      expect(params["contribution"]["abstract"]).to eq "A short description \n with wonky spaces\n\nBut keep two newlines between paragraphs."
    end
  end
end
