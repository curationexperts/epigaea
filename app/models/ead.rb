# Generated via
#  `rails generate hyrax:work Ead`
class Ead < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = EadIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Ead'

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
