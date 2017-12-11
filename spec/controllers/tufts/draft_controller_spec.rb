# coding: utf-8
require 'rails_helper'

RSpec.describe Tufts::DraftController, type: :controller do
  let(:model) { FactoryGirl.build(:pdf) }

  before { model.save }

  after do
    model.delete_draft
    model.destroy
  end

  describe 'POST #save_draft' do
    it "saves a draft for the model" do
      post :save_draft, params: { "id" => model.id, "pdf" => { "representative_id" => "q237hr920", "thumbnail_id" => "q237hr920", "title" => "Testyttyy", "displays_in" => ["", "dl"], "abstract" => [""], "accrual_policy" => "", "admin_start_date" => [""], "alternative_title" => [""], "audience" => "", "bibliographic_citation" => ["test", ""], "contributor" => [""], "corporate_name" => [""], "createdby" => ["selfdep"], "creator_department" => [""], "date_accepted" => [""], "date_available" => ["2017-11-12 23:35:36 UTC", ""], "date_copyrighted" => [""], "date_issued" => [""], "date_modified" => "2017-11-13T00:28:42+00:00", "date_uploaded" => "2017-11-12T23:35:37+00:00", "embargo_note" => "2018-11-12T23:35:37Z", "end_date" => "", "extent" => [""], "format_label" => [""], "funder" => [""], "genre" => [""], "has_format" => [""], "has_part" => [""], "held_by" => [""], "identifier" => [""], "internal_note" => "Jamie self-deposited on 2017-11-12 at 23:35:36 UTC using the Deposit Form for the Tufts Digital Library", "is_format_of" => [""], "is_replaced_by" => [""], "language" => [""], "legacy_pid" => "", "personal_name" => [""], "primary_date" => [""], "provenance" => [""], "publisher" => ["Tufts University. Digital Collections and Archives.", ""], "qr_note" => [""], "qr_status" => [""], "rejection_reason" => [""], "replaces" => [""], "resource_type" => [""], "retention_period" => [""], "rights_holder" => [""], "rights_note" => "", "geographic_name" => [""], "steward" => "dca", "subject" => [""], "table_of_contents" => [""], "temporal" => [""], "is_part_of" => [""], "rights_statement" => 'http://dca.tufts.edu/ua/access/rights-creator.html', "license" => ['http://dca.tufts.edu/ua/access/rights-creator.html'], "admin_set_id" => "admin_set/default", "member_of_collection_ids" => [""], "permissions_attributes" => { "1" => { "access" => "edit", "id" => "943d67c1-ed47-48d0-bd0f-7476610593bb/11/82/8f/f2/11828ff2-9979-4d95-a742-5ae1fb08f37d" } }, "visibility" => "open", "visibility_during_embargo" => "restricted", "embargo_release_date" => "2017-11-14", "visibility_after_embargo" => "open", "visibility_during_lease" => "open", "lease_expiration_date" => "2017-11-14", "visibility_after_lease" => "restricted", "version" => "W/\"60c82ca9e6797d107b8b21e8cb983290863de8a1\"" }, "find_child_work" => "", "new_user_name_skel" => "", "new_user_permission_skel" => "none", "new_group_name_skel" => "Select a group", "new_group_permission_skel" => "none" }
      parsed_body = JSON.parse(response.body)

      expect(parsed_body["status"]).to eq("A draft was saved.")
    end
  end

  describe 'POST #delete_draft' do
    it "deletes a draft" do
      post :delete_draft, params: { id: model.id }

      parsed_body = JSON.parse(response.body)
      expect(parsed_body["status"]).to eq("Deleted the draft.")
    end
  end
end
