shared_examples 'a form with Tufts metadata attributes' do
  # rubocop:disable RSpec/ExampleLength
  context 'and the form' do
    it 'has the required fields' do
      expect(form.required_fields).to eq([:title, :displays_in])
    end

    it 'has Tufts terms' do
      expect(form.terms)
        .to include(:displays_in, :geographic_name, :held_by,
                    :alternative_title, :abstract, :table_of_contents,
                    :primary_date, :date_accepted, :date_available,
                    :date_copyrighted, :date_issued, :steward, :created_by,
                    :internal_note, :audience, :embargo_note, :end_date,
                    :accrual_policy, :license, :rights_note, :resource_type,
                    :bibliographic_citation, :rights_holder, :format_label,
                    :replaces, :is_replaced_by, :has_format, :is_format_of,
                    :has_part, :extent, :genre, :tufts_is_part_of)
    end

    it 'has Tufts admin terms' do
      expect(form.terms)
        .to include(:steward, :created_by, :internal_note, :audience, :end_date,
                    :accrual_policy, :license, :retention_period,
                    :admin_start_date, :qr_status, :rejection_reason, :qr_note,
                    :creator_department, :legacy_pid, :personal_name,
                    :corporate_name, :provenance, :funder, :creator_department,
                    :createdby)
    end
  end
end
