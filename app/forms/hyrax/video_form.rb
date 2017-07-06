# Generated via
#  `rails generate hyrax:work Video`
module Hyrax
  class VideoForm < Hyrax::Forms::WorkForm
    self.model_class = ::Video
    self.terms += [:displays_in]
    self.required_fields = [:title, :displays_in]
  end
end
