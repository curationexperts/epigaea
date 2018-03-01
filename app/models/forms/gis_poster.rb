class GisPoster < GenericTischDeposit
  self.attributes = [:title, :degrees, :schools, :departments, :courses, :methodological_keywords, :geonames,
                     :term, :year, :topics, :geonames_placeholder,
                     :degree,
                     :description, :creator, :contributor,
                     :bibliographic_citation, :subject, :corpname, :attachment, :license]
  # def copy_attributes
  #  super
  #  @tufts_pdf.description = ["#{description}  Submitted in partial fulfillment of the grant requirement of the Tufts Summer Scholars Program."]
  # end

  def copy_attributes
    self.class.attributes
    @tufts_pdf.title = [title]
    @tufts_pdf.description = description
    @tufts_pdf.creator = [(send(:creator) unless send(:creator).nil?)]
    @tufts_pdf.tufts_license = license_data(@tufts_pdf)
    @tufts_pdf.corporate_name = corpname
    @tufts_pdf.subject = (send(:topics).nil? ? [] : Array(send(:topics))) + (send(:methodological_keywords).nil? ? [] : Array(send(:methodological_keywords)))
    @tufts_pdf.geographic_name = Array(send(:geonames)) unless send(:geonames).nil?
    @tufts_pdf.format_label = ['text']
    date_created = assign_date_created(@term)
    @tufts_pdf.date_created = [date_created]
    # TODO: refactor this for Hyrax collections
    # insert_rels_ext_relationships
  end

  attr_accessor(*attributes)

  private

    def assign_date_created(term)
      case term
      when 'Fall'
        @year + '-09-01 00:00:00 -0400'
      when 'Summer'
        @year + '-06-01 00:00:00 -0400'
      when 'Spring'
        @year + '-01-01 00:00:00 -0500'
      else
        @year + '-01-01 00:00:00 -0500'
      end
    end

    def description
      (send(:degrees).nil? ? [] : Array(send(:degrees))) + (send(:courses).nil? ? [] : Array(send(:courses)))
    end

    def corpname
      (send(:schools).nil? ? [] : Array(send(:schools))) + (send(:departments).nil? ? [] : Array(send(:departments)))
    end
end
