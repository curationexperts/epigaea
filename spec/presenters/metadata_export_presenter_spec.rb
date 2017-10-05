require 'rails_helper'

RSpec.describe MetadataExportPresenter do
  subject(:presenter) { described_class.new(export) }
  let(:batch)         { FactoryGirl.build(:batch, ids: []) }
  let(:export)        { FactoryGirl.build(:metadata_export, batch: batch) }

  it { is_expected.to have_attributes(export: export, batch: batch) }

  it { is_expected.to delegate_method(:batch).to(:export) }

  it { is_expected.to delegate_method(:count).to(:batch_presenter) }
  it { is_expected.to delegate_method(:creator).to(:batch_presenter) }
  it { is_expected.to delegate_method(:created_at).to(:batch_presenter) }
  it { is_expected.to delegate_method(:id).to(:batch_presenter) }
  it { is_expected.to delegate_method(:path).to(:batch_presenter) }
  it { is_expected.to delegate_method(:review_status).to(:batch_presenter) }
  it { is_expected.to delegate_method(:status).to(:batch_presenter) }

  describe '#download' do
    context 'without a file' do
      it 'is n/a' do
        expect(presenter.download).to eq 'n/a'
      end
    end

    context 'with a file' do
      let(:filename) { 'moomin.xml' }

      before { export.filename = filename }

      it 'is the filename' do
        expect(presenter.download).to eq filename
      end
    end
  end

  describe '#type' do
    it 'has the correct type' do
      expect(presenter.type).to eq export.batch_type
    end
  end
end
