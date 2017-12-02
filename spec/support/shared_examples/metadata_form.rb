shared_examples 'a form with Tufts metadata attributes' do
  # rubocop:disable RSpec/ExampleLength
  context 'and the form' do
    it 'has the required fields' do
      expect(form.required_fields).to eq([:title, :displays_in])
    end

    it 'has Tufts terms' do
      expect(form.terms).to include(:provenance, :displays_in, :geographic_name, :held_by, :alternative_title,
                                    :abstract, :table_of_contents, :primary_date, :date_accepted,
                                    :date_available, :date_copyrighted, :date_issued, :steward,
                                    :internal_note, :audience, :embargo_note, :end_date, :accrual_policy,
                                    :rights_note, :rights_holder, :format_label, :replaces, :is_replaced_by,
                                    :has_format, :is_format_of, :has_part, :tufts_license,
                                    :retention_period, :admin_start_date, :qr_status, :rejection_reason,
                                    :qr_note, :creator_department, :legacy_pid, :temporal, :extent,
                                    :personal_name, :corporate_name, :genre, :provenance, :funder, :createdby,
                                    :is_part_of)
    end
  end
end
