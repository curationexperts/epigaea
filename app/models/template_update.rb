##
# A model for managing and tracking template update batches.
#
# @example
#   update = TemplateUpdate.create(template_name: 'blah')
#   update.enqueue
#
# @see Tufts::Template
# @see TemplateUpdateJob
class TemplateUpdate < ApplicationRecord
  # @!attribute batch [rw]
  #   @return [Batch]
  # @!attribute behavior [rw]
  #   @return [String]
  # @!attribute ids [rw]
  #   @return [Array<String>]
  # @!attribute template_name [rw]
  #   @return [String]
  has_one :batch, as: :batchable

  serialize :ids, Array

  OVERWRITE = 'overwrite'.freeze
  PRESERVE  = 'preserve'.freeze

  TYPE_STRING = 'Template Update'.freeze

  ##
  # A struct representing a single item
  #
  # @example
  #   item = Item.new('overwrite', 'abc123', 'My Template')
  #   item.behavior      # => 'overwrite'
  #   item.id            # => 'abc123'
  #   item.template_name # => 'My Template'
  Item = Struct.new(:behavior, :id, :template_name)

  ##
  # @return [String]
  def batch_type
    TYPE_STRING
  end

  ##
  # Configurations for the update of each item in ids.
  #
  # @return [Enumerable<TemplateUpdate::Item>]
  def items
    Enumerator.new do |yielder|
      ids.each do |id|
        yielder << Item.new(behavior, id, template_name)
      end
    end
  end

  ##
  # @return [void]
  def enqueue!
    items.each { |item| TemplateUpdateJob.perform_later(*item.values) }
  end
end
