module Tufts
  module TuftsHelperBehavior
    # @return [String] only search the catalog, not dashboard
    def search_form_action
      main_app.search_catalog_path
    end
  end
end
