# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'

RSpec.describe Hyrax::AudioForm do
  let(:audio) { Audio.new }
  let(:form) { described_class.new(audio, '', '') }

  it_behaves_like 'a form with Tufts metadata attributes'
  it_behaves_like 'a form with a transcription'
end
