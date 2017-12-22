shared_examples 'a record with ordered fields' do
  describe 'ordered descriptions' do
    let(:desc_a) { 'AAA' }
    let(:desc_b) { 'BBB' }
    let(:desc_c) { 'CCC' }
    let(:expected_order) { [desc_b, desc_a, desc_c] }

    context 'an unsaved record' do
      before do
        expect(work.persisted?).to eq false
        work.description = expected_order
      end

      it 'preserves the description order' do
        expect(work.description).to eq expected_order
      end

      it 'indexes the ordered descriptions in solr' do
        expect(work.to_solr['description_tesim']).to eq expected_order
      end
    end

    context 'saving a record' do
      before do
        work.description = expected_order
        work.save!
        work.reload
      end

      it 'preserves the description order' do
        expect(work.description).to eq expected_order
      end
    end

    describe '#description' do
      context 'when ordered_descriptions field is not set' do
        # This should never happen in production mode
        # because ordered_descriptions field should
        # only be set via `description=` setter.
        # But if you directly set the
        # ordered_descriptions field in dev mode, it
        # should behave properly.
        before do
          work.description = expected_order
          work.ordered_descriptions = nil
        end

        it 'does not raise error' do
          expect(work.description).to eq expected_order
        end
      end
    end
  end
end
