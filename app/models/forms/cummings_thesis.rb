class CummingsThesis < Contribution
  protected

    def copy_attributes
      super
      @tufts_pdf.creatordept = 'UA041.007'
    end

  private

    def parent_collection
      'tufts:UA069.001.DO.UA041'
    end
end
