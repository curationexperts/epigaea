module Tufts
  ##
  # An empty changeset
  #
  # @exmaple
  #   cs = NullChangeSet.new(object, graph, changed_attributes)
  #   cs.empty?  # => true
  #   cs.changes # => {}
  #
  # @see https://en.wikipedia.org/wiki/Null_Object_pattern
  # @see ActiveFedora::ChangeSet
  class NullChangeSet
    def initialize(*); end

    def empty?
      true
    end

    def changes
      {}
    end

    def changed_attributes
      []
    end
  end
end
