shared_examples 'a work with custom Tufts validations' do
  it 'only has one title' do
    work.title = ['title', 'another title']
    work.valid?
    expect(work.errors[:title]).to include('There can be only one title')
  end
end
