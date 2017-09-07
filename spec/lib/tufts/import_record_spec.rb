require 'rails_helper'

RSpec.describe Tufts::ImportRecord do
  subject(:record) { described_class.new(file: filename) }
  let(:filename)   { '1.pdf' }

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
