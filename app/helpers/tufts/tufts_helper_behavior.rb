module Tufts
  module TuftsHelperBehavior
    # @return [String] only search the catalog, not dashboard
    def search_form_action
      main_app.search_catalog_path
    end

    def workflow_status(model)
      Hyrax::PresenterFactory.build_for(ids: [model.id],
                                        presenter_class: "Hyrax::#{model.class}Presenter".classify.safe_constantize,
                                        presenter_args: nil)[0].solr_document["workflow_state_name_ssim"]
    end
  end
end
