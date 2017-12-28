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

    describe '#description=' do
      it 'marks both "description" and "ordered_descriptions" fields as dirty so they will both be updated in fedora' do
        expect(work).to receive(:attribute_will_change!).with(:description)
        expect(work).to receive(:attribute_will_change!).with(:ordered_descriptions)
        work.description = expected_order
      end
    end
  end

  describe 'ordered creators' do
    let(:lancelot) { 'Sir Lancelot du Lac' }
    let(:gawain) { 'Sir Gawain' }
    let(:arthur) { 'King Arthur Pendragon' }
    let(:expected_order) { [arthur, gawain, lancelot] }

    context 'an unsaved record' do
      before do
        expect(work.persisted?).to eq false
        work.creator = expected_order
      end

      it 'preserves the creator order' do
        expect(work.creator).to eq expected_order
      end

      it 'indexes the ordered creators in solr' do
        expect(work.to_solr['creator_tesim']).to eq expected_order
      end
    end

    context 'saving a record' do
      before do
        work.creator = expected_order
        work.save!
        work.reload
      end

      it 'preserves the description order' do
        expect(work.creator).to eq expected_order
      end
    end

    describe '#creator=' do
      it 'marks both "creator" and "ordered_creators" fields as dirty so they will both be updated in fedora' do
        expect(work).to receive(:attribute_will_change!).with(:creator)
        expect(work).to receive(:attribute_will_change!).with(:ordered_creators)
        work.creator = expected_order
      end
    end
  end
end
