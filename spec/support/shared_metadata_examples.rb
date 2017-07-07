shared_examples 'a work with Tufts metadata attributes' do
  context 'and the list of metadata attributes' do
    it 'has displays_in' do
      work.displays_in = ['nowhere', 'trove']
      expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
    it 'has geographic_names' do
      work.geographic_name = ['China']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/spatial/)
    end
    it 'has held by' do
      work.held_by = ['United States']
      expect(work.resource.dump(:ttl)).to match(/bibframe.org\/vocab\/heldBy/)
    end
  end
end
