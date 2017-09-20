# Generated via
#  `rails generate hyrax:work Video`
require 'rails_helper'

RSpec.describe Hyrax::VideoForm do
  let(:video) { Video.new }
  let(:form) { described_class.new(video, '', '') }

  it_behaves_like 'a form with Tufts metadata attributes'
  it_behaves_like 'a form with a transcription'
end
