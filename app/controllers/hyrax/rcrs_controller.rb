# Generated via
#  `rails generate hyrax:work Rcr`

module Hyrax
  class RcrsController < Tufts::WorksController
    self.curation_concern_type = ::Rcr
    self.show_presenter = Hyrax::RcrPresenter
  end
end
