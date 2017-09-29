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
    @batch_presenter ||= BatchPresenter.new(batch)
  end

  delegate :creator, :created_at, :id, :review_status, to: :batch_presenter

  ##
  # @return [Integer]
  def count
    xml_import.records.to_a.size
  end

  ##
  # @return [Array<>]
  def items
    batch_presenter.items.map do |item|
      Item.new(item: item, import: xml_import)
    end
  end

  ##
  # @return [Enumerable<String>]
  def missing_files
    xml_import.records.map(&:file).to_a -
      xml_import.uploaded_files.map { |file| File.basename(file.file.path) }
  end

  ##
  # @return [String]
  def path
    "xml_imports/#{xml_import.id}"
  end

  ##
  # @return [String]
  # @see BatchPresenter#status
  def status
    return BatchPresenter::JOB_STATUSES[:new] unless items.any?
    items_status = batch_presenter.status

    return items_status unless
      items_status == BatchPresenter::JOB_STATUSES[:completed]

    return 'Partially Completed' if missing_files.any?
    items_status
  end

  ##
  # @return [String]
  def type
    xml_import.batch_type
  end

  ##
  # Presenter for the batch items.
  class Item
    ##
    # @param item [Batch::Item]
    def initialize(item:, import:)
      @item   = item
      @import = import
    end

    ##
    # @return [String]
    def id
      return @item.id if object.present?
      'Awaiting Assignment'
    end

    ##
    # @return [String]
    def title
      return @item.title if object.present?
      @import.record_for(file: @import.record_ids.key(@item.id)).title
    end

    delegate :reviewed?, :status, :object, to: :@item
  end
end
