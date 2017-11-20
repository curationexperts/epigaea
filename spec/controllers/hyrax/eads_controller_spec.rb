# Generated via
#  `rails generate hyrax:work Ead`
require 'rails_helper'

RSpec.describe Hyrax::EadsController, type: :controller do
  let(:params) { { id: 'impossible_id' } }

  it 'catches and redirects RecordNotFound exceptions' do
    expect { get :show, params: params }.not_to raise_error(Blacklight::Exceptions::RecordNotFound)
  end
end
