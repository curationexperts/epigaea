# Generated via
#  `rails generate hyrax:work Video`
module Hyrax
  class VideoForm < Hyrax::Forms::WorkForm
    self.model_class = ::Video
    self.terms += [:resource_type]
  end
end
