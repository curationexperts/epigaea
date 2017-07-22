require 'rails_helper'

describe Tufts::HandleDispatcher do
  subject(:dispatcher) { described_class.new(registrar: fake_registrar.new) }
  let(:object)         { build(:pdf) }
  let(:handle)         { 'hdl/tufts_1' }

  let(:fake_registrar) do
    Class.new do
      def initialize(*); end

      def register!(*)
        record        = Handle::Record.new
        record.handle = 'hdl/tufts_1'
        record
      end
    end
  end

  shared_examples 'performs handle assignment' do |method|
    it 'returns the same object' do
      expect(dispatcher.public_send(method, object: object)).to eql object
    end

    it 'assigns to the identifier attribute by default' do
      dispatcher.public_send(method, object: object)
      expect(object.identifier).to contain_exactly(handle)
    end

    it 'assigns to specified attribute when requested' do
      dispatcher.public_send(method, object: object, attribute: :keyword)
      expect(object.keyword).to contain_exactly(handle)
    end
  end

  it 'has a registrar' do
    expect(dispatcher.registrar).to be_a fake_registrar
  end

  describe '#assign_for' do
    include_examples 'performs handle assignment', :assign_for
  end

  describe '#assign_for!' do
    let(:id)     { ActiveFedora::Noid::Service.new.mint }
    let(:object) { Pdf.new(id: id, title: ['Moomin']) }

    include_examples 'performs handle assignment', :assign_for!

    it 'saves the object' do
      expect { dispatcher.assign_for!(object: object) }
        .to change { object.new_record? }
        .from(true)
        .to(false)
    end
  end
end
