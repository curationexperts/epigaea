class XmlImport < ApplicationRecord
  ##
  # @!attribute metadata_file [rw]
  #   @return [Tufts::MetadataFileUploader]
  #   @see CarrierWave::Uploader::Base
  #   @note Set with `import.metadata_file = File.open('path/to/file')`
  mount_uploader :metadata_file, Tufts::MetadataFileUploader

  validates :metadata_file, presence: true
  validate :file_is_correctly_formatted
  validate :uploaded_files_exist

  NOID_SERVICE = ActiveFedora::Noid::Service.new.freeze
  TYPE_STRING  = 'XML Import'.freeze

  ##
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable

  ##
  # @!method record?
  #   @see Tufts::Importer#has_record?
  # @!method record_for
  #   @see Tufts::Importer#record_for
  # @!method records
  #   @see Tufts::Importer#records
  delegate :record?, :record_for, :records, to: :parser

  ##
  # @!attribute uploaded_file_ids [rw]
  #   @return [Array<String>]
  # @!attribute record_ids [rw]
  #   @return [Hash<String, String>]
  serialize :uploaded_file_ids, Array
  serialize :record_ids,        Hash

  before_save :mint_ids

  ##
  # @return [String]
  def batch_type
    TYPE_STRING
  end

  ##
  # @return [Hash<String, String> a hash associating object ids with job ids
  def enqueue!
    files = uploaded_files

    object_ids.each_with_object({}) do |id, hsh|
      file = files.shift
      next if file.nil?

      filename = file.file.file.filename
      next unless record_ids.key?(filename)

      hsh[id] = ImportJob.perform_later(self, file, record_ids[filename]).job_id
    end
  end

  ##
  # @return [Array<String>]
  def object_ids
    batch ? batch.ids : []
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

    ##
    # @private Mint ids for items ready to enqueue
    def mint_ids
      return unless uploaded_file_ids_changed?

      uploaded_files.each do |file|
        filename = file.file.file.filename

        next if record_ids.key?(filename) || !record?(file: filename)
        
        id = NOID_SERVICE.mint

        record_ids[filename] = id
        batch.ids << id
      end

      batch.save if batch.ids_changed?

      true
    end
end
