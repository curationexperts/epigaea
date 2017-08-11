shared_examples 'a work with Tufts metadata attributes' do
  it_behaves_like 'and has admin metadata attributes'
  it_behaves_like 'a work with custom Tufts validations'

  context 'and the list of metadata attributes' do
    it 'has displays_in' do
      work.displays_in = ['nowhere', 'trove']
      expect(work.resource.dump(:ttl))
        .to match(/dl.tufts.edu\/terms#displays_in/)
    end

    it 'has geographic_names' do
      work.geographic_name = ['China']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/spatial/)
    end

    it 'has held by' do
      work.held_by = ['United States']
      expect(work.resource.dump(:ttl))
        .to match(/bibframe.org\/vocab\/heldBy/)
    end

    it 'has alternative title' do
      work.alternative_title = ['An alternative title']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/alternative/)
    end

    it 'has abstract' do
      work.abstract = ['A descriptive abstract']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/abstract/)
    end

    it 'has table of contents' do
      work.table_of_contents = ['Chapter 1']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/tableOfContents/)
    end

    it 'has primary date' do
      work.primary_date = ['12/31/99']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/elements\/1.1\/date/)
    end

    it 'has date accepted' do
      work.date_accepted = ['01/01/00']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/dateAccepted/)
    end

    it 'has date available' do
      work.date_available = ['01/02/00']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/available/)
    end

    it 'has date copyrighted' do
      work.date_copyrighted = ['01/03/00']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/dateCopyrighted/)
    end

    it 'has date issued' do
      work.date_issued = ['01/04/00']
      expect(work.resource.dump(:ttl))
        .to match(/ebu.ch\/metadata\/ontologies\/ebucore\/ebucore#dateIssued/)
    end

    it 'has a resource type' do
      work.resource_type = ['Collection']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/type/)
    end

    it 'has a bilographic citation' do
      work.bibliographic_citation = ['Collection']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/bibliographicCitation/)
    end

    it 'has rights_holder' do
      work.rights_holder = ['Someone']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/rightsHolder/)
    end

    it 'has format label' do
      work.format_label = ['a format label']
      expect(work.resource.dump(:ttl))
        .to match(/loc.gov\/premis\/rdf\/v1#hasFormatName/)
    end

    it 'has replaces' do
      work.replaces = ['a replacement']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/replaces/)
    end

    it 'has "is replaced by"' do
      work.is_replaced_by = ['Something that is replaced by']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/isReplacedBy/)
    end

    it 'has "has format"' do
      work.has_format = ['a format']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/hasFormat/)
    end

    it 'has "is format of"' do
      work.is_format_of = ['another format']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/isFormatOf/)
    end

    it 'has "has part"' do
      work.has_part = ['a part']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/hasPart/)
    end

    it 'has extent' do
      work.extent = ['12x12']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/extent/)
    end

    it 'has personal name' do
      work.personal_name = ['Someone']
      expect(work.resource.dump(:ttl))
        .to match(/loc.gov\/mads\/rdf\/v1#PersonalName/)
    end

    it 'has corporate name' do
      work.corporate_name = ['Something']
      expect(work.resource.dump(:ttl))
        .to match(/loc.gov\/mads\/rdf\/v1#CorporateName/)
    end

    it 'has genre' do
      work.genre = ['a genre']
      expect(work.resource.dump(:ttl))
        .to match(/loc.gov\/mads\/rdf\/v1#GenreForm/)
    end

    it 'has provenance' do
      work.provenance = ['Someone']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/provenance/)
    end

    it 'has spatial' do
      work.spatial = ['12,23']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/spatial/)
    end

    it 'has temporal' do
      work.temporal = ['20th century']
      expect(work.resource.dump(:ttl))
        .to match(/purl.org\/dc\/terms\/temporal/)
    end

    it 'has funder' do
      work.funder = ['Viewers Like You']
      expect(work.resource.dump(:ttl))
        .to match(/id.loc.gov\/vocabulary\/relators/)
    end
  end
end
