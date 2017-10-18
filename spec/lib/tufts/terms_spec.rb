RSpec.describe Tufts::Terms do
  describe 'shared_terms' do
    it 'an array of terms' do
      expect(described_class.shared_terms).to include(:displays_in)
    end
  end
  describe 'remove_terms' do
    it 'is an array of terms' do
      expect(described_class.remove_terms).to include(:based_near)
    end
  end
end
