class FacultyScholarship < Contribution
  attr_accessor(*attributes)

  protected

    def copy_attributes
      super
      @tufts_pdf.description = [description] if description
      @tufts_pdf.bibliographic_citation = [bibliographic_citation] if bibliographic_citation
      @tufts_pdf.contributor << contributor if contributor && contributor != [""]
    end

    def parent_collection
      'tufts:UA069.001.DO.PB'
    end
end
