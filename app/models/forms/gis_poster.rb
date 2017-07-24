class GisPoster < GenericTischDeposit
  self.attributes = [:title, :degrees, :schools, :departments, :courses, :methodological_keywords, :geonames,
                     :term, :year, :topics, :geonames_placeholder,
                     :degree,
                     :description, :creator, :contributor, :embargo_note,
                     :bibliographic_citation, :subject, :corpname, :attachment, :license]
  # def copy_attributes
  #  super
  #  @tufts_pdf.description = ["#{description}  Submitted in partial fulfillment of the grant requirement of the Tufts Summer Scholars Program."]
  # end

  def copy_attributes
    attributes = self.class.attributes
    @tufts_pdf.title = send(:title) unless send(:title).nil?
    @tufts_pdf.description = (send(:degrees).nil? ? [] : Array(send(:degrees))) + (send(:courses).nil? ? [] : Array(send(:courses)))
    @tufts_pdf.creator = [(send(:creator) unless send(:creator).nil?)]
    @tufts_pdf.license = license_data(@tufts_pdf)
    @tufts_pdf.corpname = (send(:schools).nil? ? [] : Array(send(:schools))) + (send(:departments).nil? ? [] : Array(send(:departments)))
    @tufts_pdf.subject = (send(:topics).nil? ? [] : Array(send(:topics))) + (send(:methodological_keywords).nil? ? [] : Array(send(:methodological_keywords)))
    @tufts_pdf.geogname = Array(send(:geonames)) unless send(:geonames).nil?
    @tufts_pdf.type = ['text']

    date_created = case @term
                   when 'Fall'
                     @year + '-09-01 00:00:00 -0400'
                   when 'Summer'
                     @year + '-06-01 00:00:00 -0400'
                   when 'Spring'
                     @year + '-01-01 00:00:00 -0500'
                   else
                     @year + '-01-01 00:00:00 -0500'
                   end

    @tufts_pdf.date_created = date_created
    insert_rels_ext_relationships

    #      if @tufts_pdf.class.defined_attributes[attribute].multiple
    #        @tufts_pdf.send("#{attribute}=", [send(attribute)])
    #      else
    #        @tufts_pdf.send("#{attribute}=", send(attribute))
    #      end
    #    end
  end

  public

  attr_accessor *attributes
end
