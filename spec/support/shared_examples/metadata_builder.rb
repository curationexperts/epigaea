shared_examples 'a MetadataBuilder' do
  subject(:builder) { described_class.new }

  describe '#build' do
    it 'builds a string' do
      expect(builder.build.to_str).to be_a String
    end
  end

  describe '#file_extension' do
    it 'is an extension' do
      expect(builder.file_extension).to match(/^\.[a-z]+$/)
    end
  end
end
