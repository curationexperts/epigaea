##
# A presenter for the XmlImport model, behaves maximally like a BatchPresenter
# for the associated batch.
class XmlImportPresenter
  ##
  # @!attribute xml_import
  #   @return [XmlImport]
  attr_accessor :xml_import

  ##
  # @!method batch
  #   @return [Batch]
  delegate :batch, to: :xml_import

  ##
  # @!method object
  #   @see #batch
  alias object batch

  ##
  # @param xml_import [XmlImport]
  def initialize(xml_import)
    @xml_import = xml_import
  end

  ##
  # @return [BatchPresenter]
  def batch_presenter
    @batch_presenter = BatchPresenter.for(object: batch)
  end

  delegate :creator, :created_at, :id, :items, :review_status, :status,
           to: :batch_presenter

  ##
  # @return [Integer]
  def count
    xml_import.records.to_a.size
  end

  ##
  # @return [Enumerable<String>]
  def missing_files
    xml_import.records.map(&:file).to_a -
      xml_import.uploaded_files.map { |file| File.basename(file.file.path) }
  end

  ##
  # @return [String]
  # @see BatchPresenter#status
  def status
    return batch_presenter::JobStatuses[:new] unless batch_presenter.items.any?
    batch_presenter.status
  end

  ##
  # @return [String]
  def type
    xml_import.batch_type
  end
end
