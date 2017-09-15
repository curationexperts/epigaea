class GenericTischDeposit < Contribution
  def tufts_pdf
    return @tufts_pdf if @tufts_pdf
    now = Time.zone.now

    note = "#{creator} self-deposited on #{now.strftime('%Y-%m-%d at %H:%M:%S %Z')} using the Deposit Form for the Tufts Digital Library"
    @tufts_pdf = Pdf.new(createdby: SELFDEP, title: [title],
                         steward: 'tisch', displays_in: ['dl'], format_label: ['application/pdf'],
                         publisher: ['Tufts University. Tisch Library.'],
                         license: ['http://dca.tufts.edu/ua/access/rights-creator.html'],
                         date_available: [now.to_s], date_uploaded: now.to_s, internal_note: note)

    copy_attributes
    @tufts_pdf
  end

  def parent_collection
    nil
  end
end
