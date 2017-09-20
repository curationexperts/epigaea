class HonorsThesis < Contribution
  self.attributes += [:department]
  self.ignore_attributes += [:department]
  attr_accessor :department
  validates :department, presence: true

  protected

    def copy_attributes
      super
      @tufts_pdf.subject = [department]
      @tufts_pdf.creator_department = [creator_dept]
    end

  private

    def creator_dept
      terms = Qa::Authorities::Local.subauthority_for('departments').all
      if department == terms.find { |t| t[:label] == department }
        term[:id]
      else
        'NEEDS FIXING'
      end
    end

    def parent_collection
      'tufts:UA069.001.DO.UA005'
    end
end
