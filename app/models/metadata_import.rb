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

  validates :metadata_file, presence: true
  validate :file_is_correctly_formatted

  ##
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable, inverse_of: :batchable

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
    @parser || Tufts::MiraXmlImporter.new(file: metadata_file.file)
  end

  def file_is_correctly_formatted
    return unless metadata_file_changed?
    number_of_errors_to_display = 5
    validation_errors = parser.validate!('metadata')
    validation_errors_count = validation_errors.count
    validation_errors = validation_errors.first(number_of_errors_to_display)
    validation_errors.each { |err| errors.add(:base, err.message) }
    errors.add(:base, "There were #{validation_errors_count} errors total, too many to display") if validation_errors_count > number_of_errors_to_display
  end
end
