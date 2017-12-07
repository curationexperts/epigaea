require 'rails_helper'

RSpec.describe ApplicationModelActor do
  subject(:actor) { described_class.new(next_actor) }

  let(:ability)    { ::Ability.new(create(:admin)) }
  let(:env)        { Hyrax::Actors::Environment.new(object, ability, {}) }
  let(:next_actor) { instance_double(Hyrax::Actors::Terminator, create: true) }
  let(:object)     { build(:pdf) }

  describe '#create' do
    it 'saves an object' do
      expect { actor.create(env) }
        .to change { object.new_record? }
        .from(true)
        .to(false)
    end

    it 'hits next actor' do
      actor.create(env)
      expect(next_actor).to have_received(:create).with(env)
    end

    it 'returns truthy' do
      expect(actor.create(env)).to be_truthy
    end

    context 'when the object exists' do
      let(:object) { create(:pdf, date_uploaded: date) }
      let(:date)   { Hyrax::TimeService.time_in_utc }

      it 'does not change date submitted' do
        expect { actor.create(env) }
          .not_to change { object.date_uploaded }
          .from date
      end

      it 'pops out of stack' do
        actor.create(env)
        expect(next_actor).not_to have_received(:create)
      end

      it 'returns false' do
        expect(actor.create(env)).to eq false
      end
    end
  end
end
