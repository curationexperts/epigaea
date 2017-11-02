# Generated via
#  `rails generate hyrax:work Ead`

module Hyrax
  class EadsController < Tufts::WorksController
    self.curation_concern_type = ::Ead
    self.show_presenter = Hyrax::EadPresenter
  end
end
