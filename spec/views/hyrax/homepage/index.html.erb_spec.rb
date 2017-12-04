# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/homepage/index.html.erb', type: :view do
  include Devise::Test::ControllerHelpers

  subject(:page) do
    render
  end

  before do
    FactoryGirl.create(:deposit_type)
  end
  context 'as a non-authenticated user' do
    it 'displays a list of deposit types' do
      expect(page).to match('Deposit Type No.')
    end

    it 'has a <ul> with a deposit-type-list selector' do
      expect(page).to match('<ul class="deposit-types-list">')
    end
  end
end
