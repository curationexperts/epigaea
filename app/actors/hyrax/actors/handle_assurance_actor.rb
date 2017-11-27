module Hyrax
  module Actors
    ##
    # An actor that ensures a handle is registered and pointing at the correct
    # object.
    #
    # Enqueues a job to mint or update a handle. The `#create` and `#update`
    # methods punt their work to `#ensure_handle`. If an actor lower in the
    # middleware stack returns `false` (an error state), nothing will be
    # equeued.
    #
    # @example use in middleware
    #   stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
    #     # middleware.use OtherMiddleware
    #     middleware.use HandleAssuranceActor
    #     # middleware.use MoreMiddleware
    #   end
    #
    #   env = Hyrax::Actors::Environment.new(object, ability, attributes)
    #   last_actor = Hyrax::Actors::Terminator.new
    #   stack.build(last_actor).create(env)
    #
    class HandleAssuranceActor < AbstractActor
      ##
      # @param env [Hyrax::Actors::Enviornment]
      #
      # @return [Boolean]
      def create(env)
        next_actor.create(env) && ensure_handle(object: env.curation_concern)
      end

      ##
      # @param env [Hyrax::Actors::Enviornment]
      #
      # @return [Boolean]
      def update(env)
        next_actor.update(env) && ensure_handle(object: env.curation_concern)
      end

      ##
      # Enqueue handle creation or update.
      #
      # If `object` has no exiting `identifier` a 'HandleRegisterJob` is
      # enqueued. If an identifier exists, a `HandleUpdateJob` is enqueued
      # instead.
      #
      # @param object [ActiveFedora::Base]
      #
      # @return [Boolean] true
      def ensure_handle(object:)
        return true unless
          object.displays_in.include?('dl') &&
          object.to_sipity_entity.try(:workflow_state_name) == 'published'

        if object.identifier.empty?
          HandleRegisterJob.perform_later(object)
        else
          HandleUpdateJob.perform_later(object)
        end
        true
      end
    end
  end
end
