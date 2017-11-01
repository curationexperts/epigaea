# Generated via
#  `rails generate hyrax:work Video`

module Hyrax
  class VideosController < Tufts::WorksController
    self.curation_concern_type = ::Video
    self.show_presenter = Hyrax::VideoPresenter
  end
end
