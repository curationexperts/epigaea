# Generated via
#  `rails generate hyrax:work Video`
module Hyrax
  class VideoForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Video
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
