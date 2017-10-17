require 'rails_helper'

def new_state
  Blacklight::SearchState.new({}, CatalogController.blacklight_config)
end

RSpec.describe HyraxHelper, type: :helper do
  describe "#search_form_action" do
    context "when the user is not in the dashboard" do
      it "returns the catalog index path" do
        allow(helper).to receive(:params).and_return(controller: "foo")
        expect(helper.search_form_action).to eq(search_catalog_path)
      end
    end

    context "when the user is on the dashboard page" do
      it "returns the catalog index path not the works path" do
        allow(helper).to receive(:params).and_return(controller: "hyrax/dashboard")
        expect(helper.search_form_action).to eq(search_catalog_path)
      end
    end
  end
end
