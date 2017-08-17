module Hyrax
  class TemplateUpdatesController < ApplicationController
    def create
      update = TemplateUpdate.create(template_update_params)
      update.enqueue!

      render plain: "OK: #{update.template_name}" # redirect_to action: 'show'
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
