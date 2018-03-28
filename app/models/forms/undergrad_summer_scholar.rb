class UndergradSummerScholar < GenericTischDeposit
  def copy_attributes
    super
    @tufts_pdf.description = ["Submitted in partial fulfillment of the grant requirement of the Tufts Summer Scholars Program."]
  end
end
