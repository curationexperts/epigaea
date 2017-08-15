require 'rails_helper'
require_relative '../../../lib/import_export/deposit_type_importer'

describe DepositTypeImporter do
  describe 'initialize' do
    it 'sets the import_file' do
      file = test_import_file
      importer = described_class.new(file)

      expect(importer.import_file).to eq file
    end
  end

  it 'raises an exception if the import file is not found' do
    importer = described_class.new('/bad/path/no/file')
    expect do
      importer.import_from_csv
    end.to raise_error(ImportFileNotFoundError)
  end

  it 'raises an exception if the import file is not CSV' do
    not_a_csv_file = File.join(fixture_path, 'hello.pdf')
    importer = described_class.new(not_a_csv_file)
    expect do
      importer.import_from_csv
    end.to raise_error(ImportFileFormatError)
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'imports CSV data' do
    DepositType.delete_all

    importer = described_class.new(test_import_file)
    importer.import_from_csv

    expect(DepositType.count).to eq 3

    pdf = DepositType.where(display_name: 'PDF Document').first
    expect(pdf)
      .to have_attributes(deposit_agreement: 'Agreement for a PDF',
                          deposit_view:      'capstone_project')

    audio = DepositType.where(display_name: 'Audio File').first
    expect(audio)
      .to have_attributes(deposit_agreement: 'Agreement for Audio',
                          deposit_view:      'honors_thesis')

    photo = DepositType.where(display_name: 'Photograph').first
    expect(photo)
      .to have_attributes(deposit_agreement: 'Agreement for a Photo',
                          deposit_view:      'generic_deposit')
  end

  it 'updates existing deposit types' do
    DepositType.delete_all
    importer = described_class.new(test_import_file)
    pdf = FactoryGirl.create(:deposit_type,
                             display_name:      'PDF Document',
                             deposit_agreement: 'old text')

    expect { importer.import_from_csv }
      .to change { DepositType.count }
      .from(1).to(3)

    pdf.reload

    expect(pdf)
      .to have_attributes(deposit_agreement: 'Agreement for a PDF',
                          deposit_view:      'capstone_project')
  end

  it 'doesnt create duplicate deposit types' do
    DepositType.delete_all
    importer =
      described_class.new(File.join(fixture_path,
                                    'import',
                                    'deposit_types_with_duplicate_entries.csv'))
    importer.import_from_csv

    expect(DepositType.count).to eq 1
    expect(DepositType.first.deposit_agreement).to eq 'Agreement 3'
  end

  def test_import_file
    File.join(fixture_path, 'import', 'deposit_types.csv')
  end
end
