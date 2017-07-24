module GisHelper
  def self.degrees
    { bachelors: 'Bachelors', masters: 'Masters', phd: 'PhD', facstaff: 'Faculty/Staff' }
  end

  def self.gis_schools
    csv_data = CSV.read(Rails.root.join('config', 'authorities', 'gis_schools.csv'), headers: true, return_headers: false)
    string_data = csv_data.map { |row| row.map { |cell| cell[1].strip } }
    string_data
  end

  def self.departments
    csv_data = CSV.read(Rails.root.join('config', 'authorities', 'departments.csv'), headers: true, return_headers: false)
    csv_data.delete('school')
    csv_data.delete('school_id')
    csv_data.delete('dept_id')
    #  headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map { |row| row.map { |cell| cell[1].strip } }
    #  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    string_data
  end

  def self.gis_categories_options
    cats = gis_categories
    uniq_a = cats.uniq(&:first)
    cat_html = ''
    uniq_a.each do |a|
      cat_html += "<optgroup label='" + a[0] + "'>"
      nested = cats.select { |row| row[0] == a[0] }
      cat_html += "<option></option>"
      nested.each do |b|
        cat_html += "<option>" + b[1] + "</option>"
      end

      cat_html += "</optgroup>"
    end
    cat_html
  end

  def self.gis_categories
    csv_data = CSV.read(Rails.root.join('config', 'authorities', 'gis_categories.csv'), headers: true, return_headers: false)
    #  headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map { |row| row.map { |cell| cell[1] } }
    #  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    string_data
  end

  def self.methodological_keywords
    csv_data = CSV.read(Rails.root.join('config', 'authorities', 'methodological_keywords.csv'), headers: true, return_headers: false)
    string_data = csv_data.map { |row| row.map { |cell| cell[1] } }
    string_data
  end

  def self.gis_courses
    csv_data = CSV.read(Rails.root.join('config', 'authorities', 'gis_courses.csv'), headers: true, return_headers: false)
    string_data = csv_data.map { |row| row.map { |cell| cell[1] } }
    string_data
  end
end
