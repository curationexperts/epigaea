require 'handle'

module Tufts
  ##
  # Builds `HandleRecord`s from Tufts models
  class HandleBuilder
    ##
    # @!attribute prefix [rw]
    #   @return [String] the handle prefix to use when building handles
    attr_accessor :prefix

    ##
    # @param prefix [String] the handle prefix to use when building handles
    def initialize(prefix: 'pfx')
      @prefix = prefix
    end

    ##
    # @note this default builder requires a `hint` which it appends to the
    #   prefix to generate the handle string.
    #
    # @param hint [#to_s] a string-able object which may be used by the builder
    #   to generate a handle. Hints may be required by some builders, while
    #   others may ignore them to generate a handle by other means.
    #
    # @return [String]
    # @raise [ArgumentError] if a handle can't be built from the provided hint.
    def build(hint: nil)
      raise(ArgumentError, "No hint provided to #{self.class}#build") if
        hint.nil?

      "#{prefix}/#{hint}"
    end
  end
end
