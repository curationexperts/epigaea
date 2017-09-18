class XmlImport < ApplicationRecord
  ##
  # @!attribute metadata_file [rw]
  #   @return [Tufts::MetadataFileUploader]
  #   @see CarrierWave::Uploader::Base
  #   @note Set with `import.metadata_file = File.open('path/to/file'`)
  mount_uploader :metadata_file, Tufts::MetadataFileUploader

  validates :metadata_file, presence: true
  validate :file_is_correctly_formatted
  validate :uploaded_files_exist

  ##
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable

  ##
  # @!method records
  #   @see Tufts::Importer#records
  delegate :records, to: :parser

  ##
  # @!attribute uploaded_file_ids [rw]
  #   @return [Array<String>]
  serialize :uploaded_file_ids, Array

  TYPE_STRING = 'XML Import'.freeze

  ##
  # @return [String]
  def batch_type
    TYPE_STRING
  end

  ##
  # @note Unlike other `Batchable`s, `XmlImport` feeds the batch a
  #   `Hyrax::UploadedFile#id`, rather than an object id to identify jobs in the
  #   batch. The object id is not yet minted at the time of enqueuing.
  #
  # @return [Hash<String, String> a hash associating file ids with job ids
  def enqueue!
    uploaded_files.each_with_object({}) do |file, hsh|
      hsh[file.id.to_s] = ImportJob.perform_later(self, file).job_id
    end
  end

  ##
  # @return [Tufts::Importer]
  def parser
    Tufts::MiraXmlImporter.new(file: metadata_file.file)
  end

  ##
  # @return [Array<Hyrax::UploadedFile>]
  def uploaded_files
    return [] if uploaded_file_ids.empty?

    Array.wrap(Hyrax::UploadedFile.find(*uploaded_file_ids))
  end

  private

    def file_is_correctly_formatted
      return unless metadata_file_changed?

      parser.validate!.each { |err| errors.add(:base, err.message) }
    end

    ##
    # @note this is a little hacky, but gets us out of having to monkeypatch
    #   Hyrax::UploadedFile to have polymorphic relations. There may be a
    #   better solution.
    def uploaded_files_exist
      return unless uploaded_file_ids_changed?
      Hyrax::UploadedFile.find(*uploaded_file_ids)
    rescue ActiveRecord::RecordNotFound => err
      errors.add(:uploaded_file_ids, err.message)
    end
end
