module Hyrax
  module Actors
    ##
    # An actor that ensures a handle is registered and pointing at the correct
    # object.
    class HandleAssuranceActor < AbstractActor
      ##
      # @param env [Hyrax::Actors::Enviornment]
      #
      # @return [Boolean] true
      def create(env)
        ensure_handle(object: env.curation_concern)
        true
      end

      ##
      # @param env [Hyrax::Actors::Enviornment]
      #
      # @return [Boolean] true
      def update(env)
        ensure_handle(object: env.curation_concern)
        true
      end

      ##
      # @param object [ActiveFedora::Base]
      #
      # @return [void]
      def ensure_handle(object:)
        if object.identifier.empty?
          HandleRegisterJob.perform_later(object)
        else
          HandleUpdateJob.perform_later(object)
        end
      end
    end
  end
end
