class Batch < ApplicationRecord
  ##
  # @!attribute creator [r]
  #   @return [User]
  belongs_to :user
  alias_attribute :creator, :user

  ##
  # @!attribute batchable [r]
  #   @return [#enqueue!]
  belongs_to :batchable, polymorphic: true

  ##
  # @!attribute ids [rw]
  #   @return [Array<String>]
  serialize :ids, Array

  ##
  # @!method job_ids
  #   @return [Array<String>]
  delegate :job_ids, to: :job_batch

  ##
  # @return [void]
  def enqueue!
    id_map = batchable.enqueue!
    return unless id_map.any?

    id_map.each { |o, j| add_job_for_object(object_id: o, job_id: j) }

    ActiveJobStatus::JobBatch.new(batch_id:   id,
                                  job_ids:    id_map.values,
                                  store_data: true)
  end

  ##
  # @return [Enumerator<ActiveFedora::Base>]
  def items
    ids.lazy.map { |obj_id| Item.new(obj_id, id) }
  end

  ##
  # Items for the batch. Items are a composite of an `ActiveFedora::Base` object
  # and its corresponding job.
  class Item
    ##
    # @!attribute batch [rw]
    #   @return [String]
    # @!attribute id [rw]
    #   @return [String]
    # @!attribute object [rw]
    #   @return [ActiveFedora::Base]
    attr_accessor :batch_id, :id, :object

    ##
    # @param id [#to_s]
    def initialize(id, batch_id)
      @id       = id
      @batch_id = batch_id
      @object   = ActiveFedora::Base.find(id)
    end

    ##
    # @return [String, nil]
    def job_id
      Tufts::JobItemStore.fetch(object_id: id, batch_id: batch_id)
    end

    ##
    # @return [Symbol]
    def status
      return :unavailable if job_id.nil?

      ActiveJobStatus.get_status(job_id)
    end

    ##
    # @return [String]
    def title
      object.title.first
    end

    ##
    # @return [Boolean]
    def reviewed?
      return object.reviewed? if object.respond_to?(:reviewed?)
      false
    end
  end

  private

    ##
    # @private
    # @note Don't expose clients to `ActiveJobStatus::JobBatch`
    # @return [ActiveJobStatus::JobBatch]
    def job_batch
      ActiveJobStatus::JobBatch.find(batch_id: id) ||
        ActiveJobStatus::JobBatch.new(batch_id:   id,
                                      job_ids:    [],
                                      store_data: false)
    end

    ##
    # @private
    def add_job_for_object(object_id:, job_id:)
      Tufts::JobItemStore
        .add(object_id: object_id, job_id: job_id, batch_id: id)
    end
end
