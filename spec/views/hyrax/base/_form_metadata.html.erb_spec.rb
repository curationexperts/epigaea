require 'rails_helper'

RSpec.describe 'hyrax/base/_form_metadata.html.erb', type: :view do
  before do
    allow(view).to receive(:current_page?).with(
      controller: 'batch_uploads',
      action: 'new'
    ).and_return(false)
  end
  context 'a video form' do
    let(:work) { FactoryGirl.create(:video) }
    let(:form) do
      Hyrax::VideoForm.new(work, ability, controller)
    end

    it_behaves_like 'a work that has transcript UI on the form'
  end

  context 'an audio form' do
    let(:work) { FactoryGirl.create(:audio) }
    let(:form) do
      Hyrax::AudioForm.new(work, ability, controller)
    end
    it_behaves_like 'a work that has transcript UI on the form'
  end
end
