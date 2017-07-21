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
    # @return [String]
    def build
      "#{prefix}/1"
    end
  end
end
