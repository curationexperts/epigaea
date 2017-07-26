class GenericTischDeposit < Contribution
  def tufts_pdf
    return @tufts_pdf if @tufts_pdf
    now = Time.zone.now

    note = "#{creator} self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
    @tufts_pdf = Pdf.new(createdby: SELFDEP,
                         steward: ['tisch'], displays: ['dl'], format: ['application/pdf'],
                         publisher: ['Tufts University. Tisch Library.'],
                         rights: ['http://dca.tufts.edu/ua/access/rights-creator.html'],
                         date_available: [now.to_s], date_submitted: [now.to_s], note: [note])

    copy_attributes
    @tufts_pdf
  end

  def parent_collection
    nil
  end
end
