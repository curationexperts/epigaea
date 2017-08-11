require 'rails_helper'

RSpec.describe Hyrax::TemplatesController, type: :controller do
  let(:template) { templates.first }

  let(:templates) do
    [Tufts::Template.new(name: 'template1'),
     Tufts::Template.new(name: 'template2')]
  end

  before { templates.each(&:save) }
  after  { Tufts::Template.all.each(&:delete) }

  context 'as admin' do
    let(:user) { FactoryGirl.create(:admin) }

    before { sign_in user }

    describe 'GET #index' do
      it 'renders index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'assigns templates' do
        get :index

        expect(assigns(:templates).map(&:name))
          .to contain_exactly('template1', 'template2')
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to index' do
        delete :destroy, params: { id: template.name }

        expect(response)
          .to redirect_to "/templates?locale=en&notice=Deleted+#{template.name}"
      end

      it 'deletes the template' do
        expect { delete :destroy, params: { id: template.name } }
          .to change { template.exists? }
          .from(true)
          .to(false)
      end
    end

    describe 'GET #edit' do
      it 'renders the edit form' do
        get :edit, params: { id: template.name }

        expect(response).to render_template :edit
      end

      it 'sets the form to GenericObjectForm' do
        get :edit, params: { id: template.name }

        expect(assigns(:form)).to be_a Hyrax::TemplateForm
      end

      it 'renders existing data'
    end

    describe 'GET #new' do
      it 'renders the edit form' do
        get :new, params: { id: template.name }
      end
    end

    # rubocop:disable RSpec/NestedGroups
    describe 'PUT #update' do
      let(:params) do
        { id:             template.name,
          generic_object: { template_name: template_name,
                            title:         [title] } }
      end

      let(:title)         { 'Comet in Moominland' }
      let(:template_name) { template.name }

      it 'updates the template' do
        put :update, params: params

        reloaded = Tufts::Template.for(name: template.name)
        expect(reloaded.changeset.changes).not_to be_empty
      end

      context 'when assigning a new name' do
        let(:template_name) { 'New Name for Template' }

        after { Tufts::Template.new(name: template_name).delete }

        it 'removes the old template' do
          put :update, params: params

          expect(template).not_to be_exists
        end

        it 'creates a new template' do
          put :update, params: params

          new_template = Tufts::Template.for(name: template_name)
          expect(new_template).to be_exists
        end
      end
    end
  end
end
