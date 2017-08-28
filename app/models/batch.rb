class Batch < ApplicationRecord
  ##
  # @!attribute creator [r]
  #   @return [User]
  belongs_to :user
  alias_attribute :creator, :user

  ##
  # @!attribute batchable [r]
  #   @return [TemplateUpdate]
  belongs_to :batchable, polymorphic: true

  ##
  # @!attribute ids [rw]
  #   @return [Array<String>]
  serialize :ids, Array

  ##
  # @return [Enumerator<ActiveFedora::Base>]
  def items
    ids.lazy.map { |id| Item.new(id) }
  end

  ##
  # Items for the batch. Items are a composite of an `ActiveFedora::Base` object
  # and its corresponding job.
  class Item
    ##
    # @!attribute job    [rw]
    # @!attribute object [rw]
    #   @return [ActiveFedora::Base]
    attr_accessor :job, :object

    ##
    # @param id [#to_s]
    def initialize(id)
      @object = ActiveFedora::Base.find(id)
      @job    = :no_job
    end
  end
end
