shared_examples 'an importer' do
  subject(:importer) { described_class.new(file: file) }

  before do
    allow(Collection).to receive(:find).and_return(true)
    raise "Define `file` with `let(:file) to use the shared examples" unless
      defined?(file)
  end

  it { is_expected.to have_attributes file: file }

  describe '.match?' do
    it 'responds to match' do
      expect(described_class).to be_respond_to :match?
    end
  end

  describe '#records' do
    context 'with empty file' do
      let(:file) { StringIO.new('') }

      it 'yields nothing' do
        expect { |b| importer.records(&b) }.not_to yield_control
      end

      it 'returns an empty enumerable' do
        expect(importer.records.to_a).to be_empty
      end
    end
  end

  describe '#validate!' do
    it 'does not add errors when valid' do
      expect { importer.validate! }
        .not_to change { importer.errors }
        .from(be_empty)
    end

    context 'with an invalid file' do
      subject(:importer) { described_class.new(file: invalid_file) }

      it 'adds an error' do
        if defined?(invalid_file)
          expect { importer.validate! }
            .to change { importer.errors }
            .from(be_empty)
        end
      end
    end
  end
end
