##
# A model for managing and batch metadata exports.
#
# @see MetadataExportJob
class MetadataExport < ApplicationRecord
  ##
  # @!attrbute filename [rw]
  #   @return [String]
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable

  TYPE_STRING = 'Export'.freeze

  ##
  # @return [String]
  def batch_type
    TYPE_STRING
  end

  ##
  # @return [Hash]
  def enqueue!
    return {} if object_ids.empty?

    job_id = MetadataExportJob.perform_later(self).job_id

    object_ids.each_with_object({}) do |id, hsh|
      hsh[id] = job_id
    end
  end

  ##
  # @return [Pathname]
  # @see MetadataExporter.path_for
  def path
    Tufts::MetadataExporter.path_for(filename: filename)
  end

  ##
  # @return [Array<String>] the ids from the batch
  def object_ids
    batch ? batch.ids : []
  end
end
