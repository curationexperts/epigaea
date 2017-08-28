##
# A presenter for the Batch model
class BatchPresenter
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
    object.creator.email
  end

  ##
  # @return [String]
  def review_status
    'Incomplete'
  end

  ##
  # @return [String]
  def status
    'Queued'
  end

  ##
  # @return [String]
  def type
    'Template Update'
  end
end
