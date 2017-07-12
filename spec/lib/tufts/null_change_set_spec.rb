require 'rails_helper'

RSpec.describe Tufts::NullChangeSet do
  subject(:change_set) { described_class.new }

  it 'eats arguments' do
    expect(described_class.new(:some, :args, blah: :blah))
      .to be_empty
  end

  describe '#empty' do
    it { is_expected.to be_empty }
  end

  describe '#changes' do
    it 'has empty changes' do
      expect(change_set.changes).to eql({})
    end
  end
end
