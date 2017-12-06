require 'rails_helper'

RSpec.describe 'hyrax/base/_form_metadata.html.erb', type: :view do
  context 'a video form' do
    let(:work) { FactoryGirl.create(:video) }
    let(:curation_concern) { work }
    let(:form) do
      Hyrax::VideoForm.new(work, ability, controller)
    end
    it_behaves_like 'a work that has transcript UI on the form'
  end

  context 'a video form' do
    let(:work) { FactoryGirl.create(:audio) }
    let(:curation_concern) { work }
    let(:form) do
      Hyrax::AudioForm.new(work, ability, controller)
    end
    it_behaves_like 'a work that has transcript UI on the form'
  end
end
