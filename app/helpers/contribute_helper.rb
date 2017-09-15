module ContributeHelper
  # Use this helper file to build constrained choice lists for self-deposit metadata input forms.
  # Follow the patterns for fletcher_degrees and tufts_departments below.
  # In general, provide a has which contains the display label you would like displayed in the selection
  # box as the hash key and the value you would like to have returned in the input field as the hash value.
  # Hashes used for selections will display in the order listed here unless further sorting is applied in the view.

  def standard_embargos
    [['None', '0'], ['6 months', '6'], ['1 year', '12'], ['2 years', '24']]
  end

  def public_health_degrees
    Qa::Authorities::Local.subauthority_for('public_health_degrees').all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def fletcher_degrees
    Qa::Authorities::Local.subauthority_for('fletcher_degrees').all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def tufts_department_labels
    Qa::Authorities::Local.subauthority_for('departments').all.map do |element|
      element[:label]
    end
  end

  def other_authors_fields(contribution, form)
    label = form.label :other_authors, class: "control-label"
    elements = label + blank_author_field + existing_author_fields(contribution)
    content_tag :div, elements, class: 'control-group'
  end

  def blank_author_field
    content_tag :div, id: 'additional_other_authors_clone' do
      html_snippet_for_one_author
    end
  end

  def existing_author_fields(contribution)
    content_tag :div, id: 'additional_other_authors_elements' do
      authors = Array(contribution.other_authors).delete_if(&:blank?)
      authors.inject(ActiveSupport::SafeBuffer.new) do |fields, auth|
        fields + html_snippet_for_one_author(auth)
      end
    end
  end

  def html_snippet_for_one_author(author = nil)
    content_tag :div, class: 'controls'  do
      field = text_field_tag 'contribution[other_authors][]', author, class: 'input-large'
      field + authors_are_optional
    end
  end

  def authors_are_optional
    content_tag :span, class: 'help-block' do
      opt = content_tag :b, 'Optional'
      opt + ' - the other authors field may be left blank'
    end
  end
end
