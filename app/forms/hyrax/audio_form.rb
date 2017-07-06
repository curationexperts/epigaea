# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioForm < Hyrax::Forms::WorkForm
    self.model_class = ::Audio
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
