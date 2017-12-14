##
# A generic batchable to support simple batch cases.
#
# This class supports a simple mapping between a batch type name and a job
# class. `#enqueue!` creates jobs of the correct type, passing in the ids
# from the associated batch.
#
# @see Batch
class BatchTask < ApplicationRecord
  # @!attribute batch [rw]
  #   @return [Batch]
  # @!attribute batch_type [rw]
  #   @return [String]
  has_one :batch, as: :batchable

  BATCH_TYPES = {
    publish: PublishJob,
    unpublish: UnpublishJob,
    revert: RevertJob
  }.freeze

  validates :batch_type,
            inclusion: { in: BATCH_TYPES.keys.map { |t| t.capitalize.to_s } }

  ##
  # @param [#to_sym] type_key
  #
  # @return [Class] a subclass of `BatchableJob`
  def self.job_for(type_key)
    BATCH_TYPES[type_key.to_sym.downcase]
  end

  ##
  # @return [Hash<String, String>] a hash associating object ids to job ids
  def enqueue!
    job = self.class.job_for(batch_type)

    ids.each_with_object({}) do |id, hsh|
      hsh[id] = job.perform_later(id).job_id
    end
  end

  ##
  # @return [Array<String>]
  def ids
    batch ? batch.ids : []
  end
end
