# Generated via
#  `rails generate hyrax:work Image`

module Hyrax
  class ImagesController < Tufts::WorksController
    self.curation_concern_type = ::Image
    self.show_presenter = Hyrax::ImagePresenter
  end
end
