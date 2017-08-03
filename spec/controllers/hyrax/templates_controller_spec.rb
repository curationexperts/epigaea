require 'rails_helper'

RSpec.describe Hyrax::TemplatesController, type: :controller do
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
  end
end
