RSpec.describe Tufts::DisplaysInService do
  describe 'select_options' do
    subject(:displays_in_service) { described_class.select_options }

    it 'has a select list' do
      expect(displays_in_service.first).to eq ["nowhere", "nowhere"]
    end
  end

  describe 'label' do
    subject(:displays_in_service) { described_class.label("nowhere") }
    it { is_expected.to eq 'nowhere' }
  end
end
