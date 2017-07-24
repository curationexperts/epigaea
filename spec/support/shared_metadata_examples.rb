shared_examples 'a work with Tufts metadata attributes' do
  it_behaves_like 'and has admin metadata attributes'
  it_behaves_like 'a work with custom Tufts validations'
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
    it 'has alternative title' do
      work.alternative_title = ['An alternative title']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/alternative/)
    end
    it 'has abstract' do
      work.abstract = ['A descriptive abstract']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/abstract/)
    end
    it 'has table of contents' do
      work.table_of_contents = ['Chapter 1']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/tableOfContents/)
    end
    it 'has primary date' do
      work.primary_date = ['12/31/99']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/date/)
    end
    it 'has date accepted' do
      work.date_accepted = ['01/01/00']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/dateAccepted/)
    end
    it 'has date available' do
      work.date_available = ['01/02/00']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/available/)
    end
    it 'has date copyrighted' do
      work.date_copyrighted = ['01/03/00']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/dateCopyrighted/)
    end
    it 'has date issued' do
      work.date_issued = ['01/04/00']
      expect(work.resource.dump(:ttl)).to match(/ebu.ch\/metadata\/ontologies\/ebucore\/ebucore#dateIssued/)
    end
    it 'has a resource type' do
      work.resource_type = ['Collection']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/type/)
    end
    it 'has a bilographic citation' do
      work.bibliographic_citation = ['Collection']
      expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/bibliographicCitation/)
    end
  end
end
