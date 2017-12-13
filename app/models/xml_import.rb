class XmlImport < ApplicationRecord # rubocop:disable Metrics/ClassLength
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
  validate :uploaded_files_exist

  NOID_SERVICE = ActiveFedora::Noid::Service.new.freeze
  TYPE_STRING  = 'XML Import'.freeze

  ##
  # @!attribute batch [rw]
  #   @return [Batch]
  has_one :batch, as: :batchable

  ##
  # @!method record?
  #   @see Tufts::Importer#record?
  # @!method record_for
  #   @see Tufts::Importer#record_for
  # @!method records
  #   @see Tufts::Importer#records
  delegate :record?, :record_for, :records, to: :parser

  ##
  # @!attribute uploaded_file_ids [rw]
  #   @return [Array<String>]
  # @!attribute record_ids [rw]
  #   A hash from filenames to NOIDs minted by the `NOID_SERVICE`.
  #   This is built and maintained by `mint_ids`.
  #   @return [Hash<String, String>]
  serialize :uploaded_file_ids, Array
  serialize :record_ids,        Hash

  before_save :prepare_records_for_enqueue

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
      next if item_processed?(id: id)

      file = files.shift
      next if file.nil?

      filename = file.file.file.filename
      next unless id_exists_for?(filename: filename)

      record = record_for(file: filename)
      next unless record.file == filename && upload_completed?(record: record)

      files_for_import = uploaded_files.select { |f| record.files.include?(f.file.file.filename) }

      hsh[id] = ImportJob.perform_later(self, files_for_import, record_ids[filename]).job_id
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
      number_of_errors_to_display = 5
      validation_errors = parser.validate!
      validation_errors_count = validation_errors.count
      validation_errors = validation_errors.first(number_of_errors_to_display)
      validation_errors.each { |err| errors.add(:base, err.message) }
      errors.add(:base, "There were #{validation_errors_count} errors total, too many to display") if validation_errors_count > number_of_errors_to_display
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
    # @return [Boolean]
    def mint_ids
      uploaded_filenames = uploaded_files.map { |up| up.file.file.filename }

      uploaded_filenames.each do |filename|
        next if id_exists_for?(filename: filename)

        record = record_for(file: filename)

        # skip unless it's the primary file and the record is complete
        next unless record.file == filename && upload_completed?(record: record)

        id = NOID_SERVICE.mint

        record_ids[filename] = id
        batch.ids << id
      end

      true
    end

    def prepare_records_for_enqueue
      return unless uploaded_file_ids_changed?

      remove_unreferenced_filenames &&
        remove_duplicate_filenames &&
        mint_ids

      batch.save if batch.ids_changed?
    end

    def id_exists_for?(filename:)
      record_ids.key?(filename) ||
        record_ids.key?(record_for(file: filename).file)
    end

    ##
    # @param [String] id
    #
    # @note It's cheaper to check for job_ids first, and we don't want to equeue
    # multiple jobs inline. This order avoids an AF round trip in most cases,
    # in favor of a lookup on `Tufts::JobItemStore` (Redis).
    def item_processed?(id:)
      item = batch.items.find { |i| i.id == id }
      item.nil? ? false : item.job_id || item.object
    end

    ##
    # @param [Hyrax::UploadedFile] file
    #
    # @return [Boolean]
    def destroy_uploaded_file(file:)
      uploaded_file_ids.delete(file.id) && file.destroy!
    end

    ##
    # Remove all but the first uploaded file for a given filename
    #
    # @return [Boolean]
    def remove_duplicate_filenames
      filenames_touched_so_far = []

      uploaded_files.sort.each do |file|
        filename = file.file.file.filename

        (destroy_uploaded_file(file: file) && next) if
          filenames_touched_so_far.include?(filename)

        filenames_touched_so_far << filename
      end

      true
    end

    ##
    # @return [Boolean]
    def remove_unreferenced_filenames
      uploaded_files.each do |file|
        destroy_uploaded_file(file: file) unless
          record?(file: file.file.file.filename)
      end

      true
    end

    ##
    # @param record [ImportRecord]
    # @return [Boolean]
    def upload_completed?(record:)
      record.files.all? do |record_file|
        uploaded_files.map { |f| f.file.file.filename }.include?(record_file)
      end
    end
end # rubocop:enable Metrics/ClassLength
