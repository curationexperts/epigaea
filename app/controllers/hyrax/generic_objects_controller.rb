# Generated via
#  `rails generate hyrax:work GenericObject`

module Hyrax
  class GenericObjectsController < Tufts::WorksController
    self.curation_concern_type = ::GenericObject
    self.show_presenter = Hyrax::GenericObjectPresenter
  end
end
