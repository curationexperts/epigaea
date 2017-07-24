require 'rails_helper'

RSpec.describe Hyrax::Actors::HandleAssuranceActor do
  subject(:actor) { described_class.new(Hyrax::Actors::Terminator.new) }
  let(:object)    { create(:pdf) }

  describe '#ensure_handle' do
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
end
