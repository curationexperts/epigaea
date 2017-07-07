shared_examples 'a work with Tufts metadata attributes' do
  context 'and the list of metadata attributes' do
    it 'has displays_in' do
      work.displays_in = ['nowhere', 'trove']
      expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#displays_in/)
    end
  end
end
