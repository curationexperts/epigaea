##
# A presenter for the Batch model
class BatchPresenter
  ##
  # Review Statuses
  REVIEW_STATUSES = { complete:   'Complete'.freeze,
                      incomplete: 'Incomplete'.freeze }.freeze

  ##
  # Job Statuses
  JOB_STATUSES = { unavailable: 'Unavailable'.freeze,
                   queued:      'Queued'.freeze,
                   working:     'In Progress'.freeze,
                   completed:   'Completed'.freeze }.freeze
  ##
  # @!attribute object [rw]
  #   @return [Batch]
  attr_accessor :object

  ##
  # @param object [Batch]
  def initialize(object)
    @object = object
  end

  class << self
    ##
    # @param object [Batch]
    #
    # @return [BatchPresenter] a batch presenter or subclass for the given
    #   object.
    def for(object:)
      new(object)
    end
  end

  delegate :created_at, :id, :items, to: :object

  ##
  # @return [String]
  def count
    object.ids.count.to_s
  end

  ##
  # @return [String]
  def creator
    object.creator.try(:email) || 'No Creator'
  end

  ##
  # @return [String]
  def review_status
    return REVIEW_STATUSES[:complete] if items.all?(&:reviewed?)
    REVIEW_STATUSES[:incomplete]
  end

  ##
  # @return [String]
  def status
    return JOB_STATUSES[:unavailable] if
      items.any? { |i| i.status == :unavailable }

    return JOB_STATUSES[:queued] unless
      items.any? { |i| [:completed, :working].include? i.status }

    return JOB_STATUSES[:working] unless
      items.all? { |i| i.status == :completed }

    JOB_STATUSES[:completed]
  end

  ##
  # @return [String]
  def type
    batchable = object.batchable

    return batchable.batch_type if batchable.respond_to?(:batch_type)
    batchable.class.to_s
  end
end
