class ActorCreate
  def initialize
    @association_strategy = FactoryGirl.strategy_by_name(:create).new
  end

  delegate :association, to: :@association_strategy

  def result(evaluation)
    evaluation.object.tap do |instance|
      evaluation.notify(:after_build, instance)

      evaluator = evaluation.instance_variable_get(:@attribute_assigner)
                            .instance_variable_get(:@evaluator)

      ability = Ability.new(user(evaluator))
      env     = Hyrax::Actors::Environment.new(instance, ability, {})

      evaluation.notify(:before_create,       instance)
      evaluation.notify(:before_actor_create, instance)
      Hyrax::CurationConcern.actor.create(env)
      evaluation.notify(:after_create,       instance)
      evaluation.notify(:after_actor_create, instance)
    end
  end

  private

    def user(evaluator)
      user = evaluator.user

      if user.nil? || user.new_record?
        raise 'You must pass a created depositing user to use the `actor_create` ' /
              "build strategy; received: #{user}"
      end

      user
    end
end
