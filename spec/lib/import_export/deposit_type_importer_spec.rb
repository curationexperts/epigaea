require 'rails_helper'
require_relative '../../../lib/import_export/deposit_type_importer'

describe DepositTypeImporter do
  describe 'initialize' do
    it 'sets the import_file' do
      file = test_import_file
      importer = described_class.new(file)
      importer.import_file.should eq(file)
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

  it 'imports CSV data' do
    DepositType.delete_all

    importer = described_class.new(test_import_file)
    importer.import_from_csv

    DepositType.count.should eq(3)

    pdf = DepositType.where(display_name: 'PDF Document').first
    pdf.deposit_agreement.should eq('Agreement for a PDF')
    pdf.deposit_view.should eq('capstone_project')
    audio = DepositType.where(display_name: 'Audio File').first
    audio.deposit_agreement.should eq('Agreement for Audio')
    audio.deposit_view.should eq('honors_thesis')
    photo = DepositType.where(display_name: 'Photograph').first
    photo.deposit_agreement.should eq('Agreement for a Photo')
    photo.deposit_view.should eq('generic_deposit')
  end

  it 'updates existing deposit types' do
    DepositType.delete_all
    importer = described_class.new(test_import_file)
    pdf = FactoryGirl.create(:deposit_type, display_name: 'PDF Document', deposit_agreement: 'old text')
    DepositType.count.should eq(1)
    importer.import_from_csv
    DepositType.count.should eq(3)
    pdf.reload
    pdf.deposit_agreement.should eq('Agreement for a PDF')
    pdf.deposit_view.should eq('capstone_project')
  end

  it 'doesnt create duplicate deposit types' do
    DepositType.delete_all
    importer = described_class.new(File.join(fixture_path, 'import', 'deposit_types_with_duplicate_entries.csv'))
    importer.import_from_csv

    DepositType.count.should eq(1)
    DepositType.first.deposit_agreement.should eq('Agreement 3')
  end

  def test_import_file
    File.join(fixture_path, 'import', 'deposit_types.csv')
  end
end
