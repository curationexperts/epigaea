shared_examples 'a batchable' do
  let(:batch) { FactoryGirl.create(:batch, ids: ids) }
  let(:ids)   { [] }

  describe '#batch' do
    it 'sets a batch' do
      expect { batchable.batch = batch }
        .to change { batchable.batch }
        .to(batch)
    end
  end

  describe '#batch_type' do
    it 'has a type string' do
      expect(batchable.batch_type).to be_a String
    end
  end

  describe '#enqueue!' do
    before { batchable.batch = batch }

    it 'returns an empty hash' do
      expect(batchable.enqueue!).to eq({})
    end

    context 'with ids in batch' do
      let(:ids) { ['abc', '123'] }

      it 'gives a hash associating ids to jobs' do
        expect(batchable.enqueue!)
          .to include('abc' => an_instance_of(String),
                      '123' => an_instance_of(String))
      end
    end
  end
end
