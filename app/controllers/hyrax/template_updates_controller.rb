module Hyrax
  class TemplateUpdatesController < ApplicationController
    def create
      update       = TemplateUpdate.new(template_update_params)
      update.batch = Batch.create(batchable: update,
                                  creator:   current_user,
                                  ids:       update.ids)
      update.save
      update.enqueue!

      redirect_to main_app.batch_path(update.batch)
    end

    def new
      ids = params[:ids] || params[:batch_document_ids] || []
      @update = TemplateUpdate.new(ids: ids)
    end

    def show
      @update = TemplateUpdate.find(param[:id])
    end

    private

      def template_update_params
        params
          .require(:template_update)
          .permit(:behavior, :template_name, ids: [])
      end
  end
end
