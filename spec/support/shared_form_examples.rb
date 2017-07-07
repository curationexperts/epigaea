shared_examples 'a form with Tufts metadata attributes' do
  context 'and the form' do
    it 'has the required fields' do
      expect(form.required_fields).to eq([:title, :displays_in])
    end
    it 'has Tufts terms' do
      expect(form.terms).to include(:title, :displays_in, :geographic_name, :held_by)
    end
  end
end
