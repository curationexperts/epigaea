class MetadataImport < ApplicationRecord
  ##
  # @!attribute metadata_file [rw]
  #   The uploaded metadata file.
  #
  #   Set with `import.metadata_file = File.open('path/to/file')`
  #
  #   @return [Tufts::MetadataFileUploader]
  #   @see CarrierWave::Uploader::Base
  mount_uploader :metadata_file, Tufts::MetadataFileUploader

  ##
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable

  TYPE_STRING = 'Metadata Import'.freeze

  ##
  # @!method record?
  #   @see Tufts::Importer#has_record?
  # @!method record_for
  #   @see Tufts::Importer#record_for
  # @!method records
  #   @see Tufts::Importer#records
  delegate :record?, :record_for, :records, to: :parser

  ##
  # @!attribute [w] parser
  #   @return [Tufts::MiraXmlImporter]
  attr_writer :parser

  ##
  # @return [String]
  def batch_type
    TYPE_STRING
  end

  ##
  # @return [Hash<String, String>]
  def enqueue!
    records.each_with_object({}) do |record, hsh|
      id      = record.id
      hsh[id] = MetadataImportJob.perform_later(self, id).job_id
    end
  end

  ##
  # @return [Enumerable<String>]
  def ids
    records.map(&:id)
  end

  ##
  # @private
  #
  # @return [Tufts::Importer]
  def parser
    @parser ||= Tufts::MiraXmlImporter.new(file: metadata_file.file)
  end
end
