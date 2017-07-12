RSpec.describe Tufts::Terms do
  describe 'shared_terms' do
    it 'an array of terms' do
      expect(described_class.shared_terms).to include(:displays_in)
    end
  end
end
