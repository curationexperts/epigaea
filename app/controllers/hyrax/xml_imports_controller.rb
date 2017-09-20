module Hyrax
  class XmlImportsController < ApplicationController
    def new
      @import = XmlImport.new
    end

    def create
      @import       = XmlImport.new(import_params)
      @import.batch = Batch.new(batchable: @import,
                                creator:   current_user,
                                ids:       [])
      if @import.save
        redirect_to main_app.xml_import_path(@import)
      else
        messages    = @import.errors.messages[:base].join("\n")
        flash.alert = " Errors were found in #{@import.metadata_file.filename}:" \
                      "\n#{messages}"
        redirect_to main_app.new_xml_import_path
      end
    end

    def edit
      @import = XmlImportPresenter.new(XmlImport.find(params[:id]))
    end

    def show
      @import = XmlImportPresenter.new(XmlImport.find(params[:id]))
    end

    def update
      @import = XmlImport.find(params[:id])

      new_files = params.fetch(:uploaded_files, [])

      if new_files.empty?
        flash.alert = 'No files added. Please upload files before submitting.'
        redirect_to main_app.edit_xml_import_path(@import)
      else
        @import.uploaded_file_ids.concat(new_files)
        @import.save

        redirect_to main_app.xml_import_path(@import),
                    notice: "Added files: #{new_files}"
      end
    end

    private

      def import_params
        params
          .require(:xml_import)
          .permit(:metadata_file)
      end
  end
end
