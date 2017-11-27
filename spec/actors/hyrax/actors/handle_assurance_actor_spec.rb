require 'rails_helper'

RSpec.describe Hyrax::Actors::HandleAssuranceActor, :clean, :workflow do
  subject(:actor)  { described_class.new(next_actor) }
  let(:next_actor) { Hyrax::Actors::Terminator.new }
  let(:object)     { actor_create(:published_pdf, displays_in: ['dl'], user: user) }
  let(:user)       { create(:user) }

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
    before do
      object
      ActiveJob::Base.queue_adapter = :test
    end

    context 'before published' do
      let(:object) { actor_create(:pdf, displays_in: ['dl'], user: user) }

      it 'does not enqueue a job' do
        expect { middleware.create(env) }.not_to enqueue_job
      end
    end

    context 'when published but not in DL' do
      let(:object) { actor_create(:published_pdf, displays_in: ['trove'], user: user) }

      it 'does not enqueue a job' do
        expect { middleware.create(env) }.not_to enqueue_job
      end
    end

    it 'enqueues a job' do
      expect { middleware.create(env) }
        .to enqueue_job.with(object)
    end

    context 'when the next middleware fails' do
      let(:next_actor) { failing_middleware.new }

      it 'does not equeue a job' do
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
    before do
      object
      ActiveJob::Base.queue_adapter = :test
    end

    context 'before published' do
      let(:object) { actor_create(:pdf, displays_in: ['dl'], user: user) }

      it 'does not enqueue a job' do
        expect { middleware.update(env) }.not_to enqueue_job
      end
    end

    context 'when published but not in DL' do
      let(:object) { actor_create(:published_pdf, displays_in: ['trove'], user: user) }

      it 'does not enqueue a job' do
        expect { middleware.update(env) }.not_to enqueue_job
      end
    end

    it 'enqueues a job' do
      expect { middleware.create(env) }
        .to enqueue_job.with(object)
    end

    context 'when the next middleware fails' do
      let(:next_actor) { failing_middleware.new }

      it 'does not equeue a job' do
        expect { middleware.create(env) }.not_to enqueue_job
      end
    end
  end
end
