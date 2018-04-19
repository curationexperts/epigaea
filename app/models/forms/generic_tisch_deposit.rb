class GenericTischDeposit < Contribution
  def tufts_pdf
    return @tufts_pdf if @tufts_pdf
    now = Time.zone.now
    note = "#{creator} self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
    @tufts_pdf = Pdf.new(
      createdby: [SELFDEP],
      depositor: @depositor,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      creator: [creator],
      title: [title],
      steward: 'tisch',
      displays_in: ['dl'],
      format_label: ['application/pdf'],
      publisher: ['Tufts University. Tisch Library.'],
      tufts_license: ['http://dca.tufts.edu/ua/access/rights-creator.html'],
      date_available: [now.to_s],
      date_uploaded: now.to_s,
      internal_note: note
    )
    copy_attributes
    add_to_collection
    user = ::User.find_by_user_key(@depositor)
    current_ability = ::Ability.new(user)
    uploaded_file = Hyrax::UploadedFile.create(user: user, file: @attachment)
    attributes = { uploaded_files: [uploaded_file.id] }
    env = Hyrax::Actors::Environment.new(@tufts_pdf, current_ability, attributes)
    Hyrax::CurationConcern.actor.create(env)
    @tufts_pdf
  end

  def copy_attributes
    super
  end

  def parent_collection
    nil
  end
end
