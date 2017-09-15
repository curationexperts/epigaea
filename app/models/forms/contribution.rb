class Contribution
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validates :title, presence: true, length: { maximum: 250 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :creator, presence: true
  validates :attachment, presence: true
  validate  :attachment_has_valid_content_type

  class_attribute :ignore_attributes, :attributes

  self.ignore_attributes = [:attachment]

  self.attributes = [:title, :description, :creator, :contributor, :bibliographic_citation, :subject, :attachment, :license, :embargo_note]

  SELFDEP = 'selfdep'.freeze

  def persisted?
    false
  end

  def tufts_pdf
    return @tufts_pdf if @tufts_pdf
    now = Time.zone.now
    note = "#{creator} self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
    @tufts_pdf = Pdf.new(
      createdby: SELFDEP,
      depositor: @depositor,
      contributor: [creator],
      title: [title],
      steward: 'dca',
      displays_in: ['dl'],
      publisher: ['Tufts University. Digital Collections and Archives.'],
      rights_statement: ['http://dca.tufts.edu/ua/access/rights-creator.html'],
      date_available: [now.to_s],
      date_uploaded: now.to_s,
      internal_note: note
    )
    copy_attributes
    user = User.find_by(email: @depositor)
    current_ability = ::Ability.new(user)
    uploaded_file = Hyrax::UploadedFile.create(user: user, file: @attachment)
    byebug
    attributes = { uploaded_files: [uploaded_file.id] }
    env = Hyrax::Actors::Environment.new(@tufts_pdf, current_ability, attributes)
    Hyrax::CurationConcern.actor.create(env)
    @tufts_pdf
  end

  def initialize(data = {})
    @deposit_type = data.delete(:deposit_type)
    @depositor = data.delete(:depositor)
    self.class.attributes.each do |attribute|
      send("#{attribute}=", data[attribute])
    end
  end

  def save
    return false unless valid?
    # ArchivalStorageService.new(tufts_pdf, attachment).run
    tufts_pdf.save!
    tufts_pdf
  end

  def self.create(attrs)
    form = new(attrs)
    form.save
  end

protected

  def copy_attributes
    (self.class.attributes - self.class.ignore_attributes).each do |attribute|
      if @tufts_pdf.class.multiple?(attribute)
        @tufts_pdf.public_send(attribute, [attribute])
      else
        @tufts_pdf.public_send(attribute, attribute)
      end
    end
    @tufts_pdf.license = license_data(@tufts_pdf)
    insert_embargo_date
  end

  def parent_collection
    'tufts:UA069.001.DO.PB'
  end

  def license_data(contribution)
    return contribution.license unless @deposit_type
    contribution.license = Array(contribution.license)
    contribution.license << @deposit_type.license_name
  end

  def insert_embargo_date
    return unless @tufts_pdf
    @tufts_pdf.embargo_note = (Time.zone.now + embargo_note.to_i.months).iso8601 unless (embargo_note || '0').eql? '0'
  end

  def insert_rels_ext_relationships
    return unless @tufts_pdf
    @tufts_pdf.stored_collection_id = parent_collection
    @tufts_pdf.rels_ext.serialize!
  end

  def attachment_has_valid_content_type
    return unless attachment
    errors.add(:attachment, "is a #{attachment.content_type} file. It must be a PDF file.") unless attachment.content_type == 'application/pdf'
  end

  public

  attr_accessor(*attributes)
end
