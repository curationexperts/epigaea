##
# A presenter for the MetadataExport model, behaves maximally like a
# BatchPresenter for the associated batch.
#
# @see BatchPresenter
class MetadataExportPresenter
  ##
  # @!attribute xml_import
  #   @return [XmlImport]
  attr_accessor :export

  ##
  # @!method batch
  #   @return [Batch]
  delegate :batch, to: :export

  ##
  # @!method object
  #   @see #batch
  alias object batch

  ##
  # @param export [MetadataExport]
  def initialize(export)
    @export = export
  end

  ##
  # @!method count
  #   @see BatchPresenter#count
  # @!method creator
  #   @see BatchPresenter#creator
  # @!method created_at
  #   @see BatchPresenter#created_at
  # @!method id
  #   @see BatchPresenter#id
  # @!method items
  #   @see BatchPresenter#items
  # @!method path
  #   @see BatchPresenter#path
  # @!method review_status
  #   @see BatchPresenter#review_status
  # @!method status
  #   @see BatchPresenter#status
  delegate :count, :creator, :created_at, :id, :items, :path, :review_status,
           :status, to: :batch_presenter

  ##
  # @return [BatchPresenter]
  def batch_presenter
    @batch_presenter ||= BatchPresenter.new(batch)
  end

  ##
  # @return [String]
  def download
    download_ready? ? export.filename : 'n/a'
  end

  ##
  # @return [Boolean]
  def download_ready?
    !export.filename.nil?
  end

  ##
  # @return [String]
  def type
    export.batch_type
  end
end
