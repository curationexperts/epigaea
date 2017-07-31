require 'rails_helper'
require_relative '../../../lib/import_export/deposit_type_exporter'

describe DepositTypeExporter do
  let(:pdf_type) { FactoryGirl.create(:deposit_type, display_name: pdf_name, deposit_agreement: pdf_agreement, deposit_view: pdf_view, license_name: pdf_license) }
  let(:audio_type) { FactoryGirl.create(:deposit_type, display_name: audio_name, deposit_agreement: audio_agreement, license_name: audio_license, deposit_view: audio_view) }

  describe 'initialize' do
    it 'sets the export_dir' do
      dir = '/path/to/my/export/dir'
      exporter = described_class.new(dir)
      exporter.export_dir.should eq(dir)
    end

    it 'sets the filename' do
      filename = 'my_export_file.csv'
      exporter = described_class.new('/tmp', filename)
      exporter.filename.should eq(filename)
    end

    it 'sets a default filename' do
      time = Time.zone.local(2012, 1, 1, 5, 15, 45)
      Time.stub(:now).and_return(time)
      exporter = described_class.new
      exporter.filename.should eq('deposit_type_export_2012_01_01_051545.csv')
    end
  end

  it 'creates the export dir if it doesnt already exist' do
    dir = test_export_dir
    exporter = described_class.new(dir)
    File.exist?(dir).should be_falsey
    exporter.create_export_dir
    File.exist?(dir).should be_truthy
    FileUtils.rm_rf(dir, secure: true)
  end

  it 'knows which columns to export' do
    column_names = DepositType.columns.map(&:name)
    excluded_columns = ['id', 'updated_at', 'created_at']
    expected_cols = column_names - excluded_columns

    cols = described_class.columns_to_include_in_export
    expected_cols.sort.should eq(cols.sort)
  end

  it 'exports the deposit types to a csv file' do
    DepositType.delete_all

    dir = test_export_dir
    exporter = described_class.new(dir)
    exporter.export_to_csv

    file = File.join(exporter.export_dir, exporter.filename)
    contents = File.readlines(file).map(&:strip)

    expected_headers = ['license_name', 'display_name', 'deposit_agreement', 'deposit_view']
    contents[0].split(',').sort.should eq(expected_headers.sort)

    FileUtils.rm_rf(dir, secure: true)
  end

  def test_export_dir
    timestamp = Time.zone.now.strftime("%Y_%m_%d_%H%M%S%N")
    Rails.root.join('tmp', "export_test_#{timestamp}")
  end
end
