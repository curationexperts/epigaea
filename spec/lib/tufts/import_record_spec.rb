require 'rails_helper'

RSpec.describe Tufts::ImportRecord do
  subject(:record) { described_class.new(file: filename) }
  let(:id)         { 'IMPORT_RECORD_FAKE_ID' }
  let(:filename)   { '1.pdf' }
  let(:title)      { 'Comet in Moominland' }

  describe '#build_object' do
    it 'builds a GenericObject by default' do
      expect(record.build_object).to be_a GenericObject
    end

    it 'can accept an id' do
      expect(record.build_object(id: id)).to have_attributes(id: id)
    end

    it 'can defer on id' do
      object       = record.build_object
      object.title = [title] # make object valid

      expect { object.save }
        .to change { object.id }
        .from(nil).to(an_instance_of(String))
    end

    context 'with metadata' do
      before { record.title = title }

      it 'assigns metadata' do
        expect(record.build_object)
          .to have_attributes(title: [title])
      end
    end
  end

  describe '#file' do
    it 'has a filename' do
      expect(record.file).to eq filename
    end

    it 'sets the filename' do
      new_filename = 'NEW_FILENAME.pdf'

      expect { record.file = new_filename }
        .to change { record.file }
        .to new_filename
    end
  end
end
