class Hyrax::MetadataImportsController < ApplicationController
  def new
    @import = MetadataImport.new
  end

  def create
    import = MetadataImport.new(import_params)
    if import.save # upload the file
      import.update!(batch: Batch.create(batchable: import,
                                         creator:   current_user,
                                         ids:       import.ids.to_a))
      import.batch.enqueue!
      redirect_to main_app.batches_path(import.batch)
    else
      messages = import.errors.messages[:base].join("\n")
      flash.alert = " Errors were found in #{@import.metadata_file.filename}:" \
                    "\n#{messages}"
      redirect_to main_app.new_metadata_import_path
    end
  end

  private

    ##
    # @private
    def import_params
      params.require(:metadata_import).permit(:metadata_file)
    end
end
