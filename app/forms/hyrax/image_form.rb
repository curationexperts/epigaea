# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    include Tufts::Forms
    self.model_class = ::Image
    self.terms += shared_terms
    self.required_fields = [:title, :displays_in]
  end
end
