require 'rails_helper'

RSpec.describe Tufts::DraftController, type: :controller do
  let(:model) { FactoryGirl.build(:pdf) }

  before do
    model.save
  end
  after do
    model.delete
  end

  describe 'PATCH #save_draft' do
    it "saves a draft for the model" do
      patch :save_draft, params: { "id" => model.id, "pdf" => { "title" => "another test thing ", "displays_in" => ["", "nowhere"],
                                                                "representative_id" => "0z708w40c", "thumbnail_id" => "0z708w40c",
                                                                "creator" => [""], "contributor" => [""], "description" => [""], "keyword" => [""],
                                                                "license" => "#<ActiveTriples::Relation:0x007faba5ea15c0>", "rights_statement" => "",
                                                                "publisher" => [""], "date_created" => [""], "subject" => [""], "language" => [""],
                                                                "identifier" => [""], "based_near_attributes" => { "0" => { "hidden_label" => "",
                                                                                                                            "id" => "",
                                                                                                                            "_destroy" => "" } },
                                                                "related_url" => [""], "source" => [""], "geographic_name" => [""], "held_by" => [""],
                                                                "alternative_title" => [""], "abstract" => [""], "table_of_contents" => [""],
                                                                "primary_date" => [""], "date_accepted" => [""], "date_available" => [""],
                                                                "date_copyrighted" => [""], "date_issued" => [""], "steward" => "", "created_by" => "",
                                                                "internal_note" => "", "audience" => "", "embargo_note" => "", "end_date" => "",
                                                                "accrual_policy" => "", "rights_note" => "", "rights" => "", "resource_type" => [""],
                                                                "admin_set_id" => "admin_set/default", "member_of_collection_ids" => [""],
                                                                "visibility_during_embargo" => "restricted", "embargo_release_date" => "2017-07-19",
                                                                "visibility_after_embargo" => "open", "visibility_during_lease" => "open",
                                                                "lease_expiration_date" => "2017-07-19", "visibility_after_lease" => "restricted",
                                                                "visibility" => "restricted", "version" => "W/\"ec5446d5fb67066ad7557d1f2d76530f0c0912d3\"" },
                                   "find_child_work" => "", "new_user_name_skel" => "",
                                   "new_user_permission_skel" => "none", "new_group_name_skel" => "Select a group",
                                   "new_group_permission_skel" => "none", "agreement" => "1" }

      expect(response.code).to eq("200")
    end
  end
  describe 'GET #apply_draft' do
    it "applies a draft" do
      get :apply_draft, params: { id: model.id }
      expect(response.code).to eq("200")
    end
  end
end
