require 'rails_helper'

RSpec.describe XmlImportPresenter do
  subject(:presenter) { described_class.new(import) }
  let(:import)        { FactoryGirl.build(:xml_import) }

  it { is_expected.to delegate_method(:batch).to(:xml_import) }

  it { is_expected.to delegate_method(:creator).to(:batch_presenter) }
  it { is_expected.to delegate_method(:created_at).to(:batch_presenter) }
  it { is_expected.to delegate_method(:id).to(:batch_presenter) }
  it { is_expected.to delegate_method(:items).to(:batch_presenter) }
  it { is_expected.to delegate_method(:review_status).to(:batch_presenter) }
  it { is_expected.to delegate_method(:status).to(:batch_presenter) }

  describe '#count' do
    it 'reflects the count of records in the import file' do
      expect(presenter.count).to eq 2
    end
  end

  describe '#missing_files' do
    it 'contains the record files' do
      expect(presenter.missing_files)
        .to contain_exactly(*import.parser.records.map(&:file))
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
        remaining_files = import.parser.records.map(&:file).to_a - [filename]

        expect(presenter.missing_files).to contain_exactly(*remaining_files)
      end
    end
  end

  describe '#type' do
    it 'has the correct type' do
      expect(presenter.type).to eq import.batch_type
    end
  end
end
