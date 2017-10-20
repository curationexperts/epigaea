require 'rails_helper'

describe Tufts::MetadataImportService, :workflow do
  subject(:service) { described_class.new(import: import, object_id: object.id) }
  let(:import)      { FactoryGirl.create(:metadata_import) }

  let!(:object) do
    FactoryGirl.create(:pdf, id: import.ids.first, title: ['Moomin'])
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
  end
end
