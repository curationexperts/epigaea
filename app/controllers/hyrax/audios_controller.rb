# Generated via
#  `rails generate hyrax:work Audio`

module Hyrax
  class AudiosController < Tufts::WorksController
    self.curation_concern_type = ::Audio
    self.show_presenter = Hyrax::AudioPresenter
  end
end
