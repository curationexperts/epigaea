shared_examples 'and has admin metadata attributes' do
  it 'has steward' do
    work.steward = 'A steward'
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#steward/)
  end
  it 'has created_by' do
    work.created_by = 'an individual'
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#createdBy/)
  end
  it 'has internal_note' do
    work.internal_note = 'An internal note'
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#internal_note/)
  end
  it 'has audience' do
    work.audience = 'An audience'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/audience/)
  end
  it 'has an end_date' do
    work.end_date = '01/01/18'
    expect(work.resource.dump(:ttl)).to match(/loc.gov\/premis\/rdf\/v1#hasEndDate/)
  end
  it 'has a embargo_note' do
    work.embargo_note = '01/01/18'
    expect(work.resource.dump(:ttl)).to match(/loc.gov\/premis\/rdf\/v1#TermOfRestriction/)
  end
  it 'has an accrual_policy' do
    work.accrual_policy = 'an accrual policy'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/accrualPolicy/)
  end
end
