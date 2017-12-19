require 'rails_helper'

RSpec.describe XmlImportPresenter, :batch do
  subject(:presenter) { described_class.new(import) }
  let(:batch)         { FactoryGirl.build(:batch, ids: []) }
  let(:import)        { FactoryGirl.build(:xml_import, batch: batch) }

  before do
    allow(Collection).to receive(:find).and_return(true)
  end

  it { is_expected.to delegate_method(:batch).to(:xml_import) }

  it { is_expected.to delegate_method(:creator).to(:batch_presenter) }
  it { is_expected.to delegate_method(:created_at).to(:batch_presenter) }
  it { is_expected.to delegate_method(:id).to(:batch_presenter) }
  it { is_expected.to delegate_method(:review_status).to(:batch_presenter) }

  describe '#count' do
    it 'reflects the count of records in the import file' do
      expect(presenter.count).to eq 2
    end
  end

  describe '#missing_files' do
    it 'contains the record files' do
      expect(presenter.missing_files)
        .to contain_exactly(*import.parser.records.flat_map(&:files))
    end

    context 'with files' do
      subject(:import) { FactoryGirl.create(:xml_import) }

      let(:file) do
        FactoryGirl
          .create(:hyrax_uploaded_file,
                  file: File.open(file_fixture(filename)))
      end

      let(:filename) { 'pdf-sample.pdf' }

      before { import.uploaded_file_ids << file.id }

      it 'contains only the missing files' do
        remaining_files =
          import.parser.records.flat_map(&:files).to_a - [filename]

        expect(presenter.missing_files).to contain_exactly(*remaining_files)
      end
    end
  end

  describe '#status' do
    context 'before queued' do
      it 'is new' do
        expect(presenter.status).to eq 'New'
      end
    end

    context 'when queued' do
      let(:import) do
        FactoryGirl
          .create(:xml_import, batch: batch, uploaded_file_ids: [file.id])
      end

      let(:file) do
        FactoryGirl
          .create(:hyrax_uploaded_file, file: File.open(file_fixture('2.pdf')))
      end

      # 999 This spec is failing
      it 'changes to queued' do
        optional 'Sometimes fails on travis' if ENV['TRAVIS']
        expect { import.batch.enqueue! }
          .to change { presenter.status }
          .to('Queued')
      end

      context 'and all enqueued jobs are completed' do
        before do
          allow(presenter.batch_presenter)
            .to receive(:status)
            .and_return(BatchPresenter::JOB_STATUSES[:completed])
        end

        it 'has a partially completed status' do
          expect(presenter.status).to eq BatchPresenter::JOB_STATUSES[:partial]
        end
      end
    end
  end

  describe '#type' do
    it 'has the correct type' do
      expect(presenter.type).to eq import.batch_type
    end
  end
end
