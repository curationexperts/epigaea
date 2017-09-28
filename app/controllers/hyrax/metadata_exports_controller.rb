module Hyrax
  class MetadataExportsController < ApplicationController
    def create
      ids = params[:ids] || params[:batch_document_ids] || []

      export       = MetadataExport.new
      export.batch = Batch.create(batchable: export,
                                  creator:   current_user,
                                  ids:       ids)

      export.save!
      export.batch.enqueue!

      redirect_to main_app.batch_path(export.batch)
    end

    def download
      export   = MetadataExport.find(params.require(:id))
      filename = export.filename

      raise(ActionController::RoutingError, 'Not Found') unless filename

      # we trust our own file extensions to give good hints to MIME::TYPES
      send_file export.path
    end
  end
end
