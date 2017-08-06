require 'rails_helper'

RSpec.describe Hyrax::TemplatesController, type: :controller do
  let(:template) { templates.first }

  let(:templates) do
    [Tufts::Template.new(name: 'template1'),
     Tufts::Template.new(name: 'template2')]
  end

  before { templates.each(&:save) }
  after  { templates.each(&:delete) }

  context 'as admin' do
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

        expect(response).to render_template :index
      end

      it 'deletes the template' do
        expect { delete :destroy, params: { id: template.name } }
          .to change { template.exists? }
          .from(true)
          .to(false)
      end
    end
  end
end
