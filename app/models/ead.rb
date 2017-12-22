# Generated via
#  `rails generate hyrax:work Ead`
class Ead < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Tufts::Draftable
  self.indexer = EadIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  validates :title, length: {
    maximum: 1,
    message: 'There can be only one title'
  }
  self.human_readable_type = 'EAD'

  include ::Tufts::Metadata::Descriptive
  include ::Tufts::Metadata::Adminstrative

  # Do not define any properties after OrderedFields
  # is included.  See ordered_fields.rb for more info.
  include ::Tufts::Metadata::OrderedFields
end
