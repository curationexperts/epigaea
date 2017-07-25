require 'rails_helper'

RSpec.describe Hyrax::Actors::HandleAssuranceActor do
  subject(:actor)  { described_class.new(next_actor) }
  let(:next_actor) { Hyrax::Actors::Terminator.new }
  let(:object)     { create(:pdf) }
  let(:user)       { User.new }

  let(:env) do
    Hyrax::Actors::Environment.new(object, Ability.new(user), {})
  end

  let(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(next_actor)
  end

  let(:failing_middleware) do
    Class.new do
      def create(*)
        false
      end

      def update(*)
        false
      end
    end
  end

  describe '#create' do
    it 'enqueues a job' do
      ActiveJob::Base.queue_adapter = :test

      expect { middleware.create(env) }
        .to enqueue_job.with(object)
    end

    context 'when the next middleware fails' do
      let(:next_actor) { failing_middleware.new }

      it 'does not equeue a job' do
        ActiveJob::Base.queue_adapter = :test
        expect { middleware.create(env) }.not_to enqueue_job
      end
    end
  end

  describe '#ensure_handle' do
    it 'returns true' do
      expect(actor.ensure_handle(object: object)).to be true
    end

    context 'without existing handle' do
      it 'queues a job to register the handle' do
        ActiveJob::Base.queue_adapter = :test

        expect { actor.ensure_handle(object: object) }
          .to enqueue_job(HandleRegisterJob)
          .with(object)
      end
    end

    context 'with an existing handle' do
      before { object.identifier = ['hdl/hdl1'] }

      it 'queues a job to update the handle' do
        ActiveJob::Base.queue_adapter = :test

        expect { actor.ensure_handle(object: object) }
          .to enqueue_job(HandleUpdateJob)
          .with(object)
      end
    end
  end

  describe '#update' do
    it 'enqueues a job' do
      ActiveJob::Base.queue_adapter = :test

      expect { middleware.create(env) }
        .to enqueue_job.with(object)
    end

    context 'when the next middleware fails' do
      let(:next_actor) { failing_middleware.new }

      it 'does not equeue a job' do
        ActiveJob::Base.queue_adapter = :test
        expect { middleware.create(env) }.not_to enqueue_job
      end
    end
  end
end
