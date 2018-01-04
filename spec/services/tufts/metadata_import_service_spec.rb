require 'rails_helper'

describe Tufts::MetadataImportService, :workflow, :clean do
  subject(:service) { described_class.new(import: import, object_id: object.id) }
  let(:file) { File.open('spec/fixtures/files/mira_export.xml') }
  let(:mira_export_ids) { ['sx61dm28w', '37720c723', 'cz30ps66x', 'hh63sv88v', 'k0698748f'] }
  let(:import) do
    FactoryGirl.create(:metadata_import, metadata_file: file)
  end

  let(:object) do
    Pdf.find(mira_export_ids.first)
  end

  # All of the files we are updating must exist before the metadata import object can be created
  before do
    mira_export_ids.each do |id|
      FactoryGirl.create(:pdf, id: id)
    end
  end

  after do
    file.close
  end

  it 'has import and object_ids attributes' do
    is_expected.to have_attributes(import:    import,
                                   object_id: object.id)
  end

  describe '#update_object!' do
    it 'updates the object' do
      expect { service.update_object! }
        .to change { object.reload.title }
        .to contain_exactly('I Married a Electric Ninjas')
    end

    context 'when existing attributes are removed from metadata file' do
      let(:file) { File.open(File.join(fixture_path, 'files', 'record_123.xml')) }
      let!(:object) do
        FactoryGirl.create(
          :pdf,
          id: '123',
          title: ['Moomin'],
          abstract: ['existing abstract'],
          subject: ['Poetry', 'existing subject']
        )
      end

      it 'removes those attributes from the object' do
        service.update_object!
        object.reload
        expect(object.title).to eq ['Sonnets from the Portuguese']
        expect(object.subject).to eq ['Poetry']
        expect(object.abstract).to eq []
      end
    end
  end
end
