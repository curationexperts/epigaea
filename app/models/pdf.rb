# Generated via
#  `rails generate hyrax:work Pdf`
class Pdf < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Tufts::Draftable
  self.indexer = PdfIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  validates :title, length: {
    maximum: 1,
    message: 'There can be only one title'
  }
  self.human_readable_type = 'PDF'

  include ::Tufts::Metadata::Descriptive
  include ::Tufts::Metadata::Adminstrative
  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
