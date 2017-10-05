class FacultyScholarship < Contribution
  self.attributes += [:other_authors]
  self.ignore_attributes += [:other_authors]
  attr_accessor(*attributes)

  protected

    def copy_attributes
      super
      @tufts_pdf.description = [description] if description
      @tufts_pdf.bibliographic_citation = [bibliographic_citation] if bibliographic_citation
      @tufts_pdf.creator << other_authors if other_authors && other_authors != [""]
    end

    def parent_collection
      'tufts:UA069.001.DO.PB'
    end
end
