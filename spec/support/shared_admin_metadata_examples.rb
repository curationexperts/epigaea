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
  it 'has license' do
    work.license = ['A license DCA Detailed Rights']
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/rights/)
  end
  it 'has rights note' do
    work.rights_note = 'A note about DCA Detailed Rights'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/rights/)
  end
  it 'has legacy pid' do
    work.legacy_pid = 'atestpid'
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#legacy_pid/)
  end
  it 'has retention period' do
    work.retention_period = ['10 days']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#retention_period/)
  end
  it 'has start date' do
    work.admin_start_date = ['01/15/2017']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#startDate/)
  end
  it 'has qr status' do
    work.qr_status = ['qr status']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#qr_status/)
  end
  it 'has rejection reason' do
    work.rejection_reason = ['A rejection']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#rejection_reason/)
  end
  it 'has quality review note' do
    work.qr_note = ['A note about the quality review']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#qr_note/)
  end
  it 'has creator department' do
    work.creator_department = ['A creator department']
    expect(work.resource.dump(:ttl)).to match(/dl.tufts.edu\/terms#creator_department/)
  end
end
