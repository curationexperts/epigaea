shared_examples 'an ActiveJob job' do
  subject(:job) { described_class.new }

  it { is_expected.to respond_to :perform }
end
