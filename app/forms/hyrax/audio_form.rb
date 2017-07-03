# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    self.model_class = ::Audio
    self.terms += [:resource_type]
  end
end
