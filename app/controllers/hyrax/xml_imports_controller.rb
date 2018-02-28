module Hyrax
  class XmlImportsController < ApplicationController
    def new
      @import = XmlImport.new
    end

    def create
      @import       = XmlImport.new(import_params)
      @import.batch = Batch.create(batchable: @import,
                                   creator:   current_user,
                                   ids:       [])
      if @import.save
        redirect_to main_app.xml_import_path(@import)
      else
        messages    = @import.errors.messages[:base].join("\n")
        flash.alert = ' Errors were found in ' \
                      "#{@import.metadata_file.file.original_filename}:" \
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

      if uploaded_file_ids.empty?
        flash.alert = 'No files added. Please upload files before submitting.'
        redirect_to main_app.edit_xml_import_path(@import)
      else
        # get filenames before save! cleans up mismatches
        new_files = filename_hash(uploaded_file_ids)

        @import.uploaded_file_ids.concat(uploaded_file_ids)
        @import.save!
        @import.batch.enqueue!

        prepare_notices!(@import, new_files)
        redirect_to main_app.xml_import_path(@import)
      end
    end

    private

      ##
      # @private
      def import_params
        params
          .require(:xml_import)
          .permit(:metadata_file)
      end

      ##
      # @private
      # @return [Array<Integer>]
      def uploaded_file_ids
        params.fetch(:uploaded_files, []).map(&:to_i)
      end

      ##
      # @private
      # @param ids [Array<Integer>]
      #
      # @return [Hash<Integer, String>]
      def filename_hash(ids)
        Hyrax::UploadedFile.find(ids).each_with_object({}) do |file, hsh|
          hsh[file.id] = file.file.file.filename
        end
      end

      ##
      # @private
      # @param import    [XmlImport]
      # @param filenames [Hash<Integer, String>]
      #
      # @return [void]
      def prepare_notices!(import, filenames)
        added, rejected = filenames.keys.partition do |id|
          import.uploaded_file_ids.include?(id)
        end

        flash.notice = added_notice(added, filenames) if added.any?

        return if rejected.empty?

        exists, unmatched =
          rejected.partition { |id| import.record_ids.key?(filenames[id]) }

        flash.alert = ''

        flash.alert.concat(unmatched_notice(unmatched, filenames)) if unmatched.any?
        flash.alert.concat(exists_notice(exists, filenames))       if exists.any?
      end

      ##
      # @private
      # @return [String]
      def added_notice(added, filenames)
        return "Added #{added.count} files." if added.count > 10

        "Added files: #{added.map { |id| filenames[id] }.join(', ')}"
      end

      ##
      # @private
      # @return [String]
      def unmatched_notice(unmatched, filenames)
        return "#{unmatched.count} files did not match." if unmatched.count > 10

        'Files did not match: ' \
        "#{unmatched.map { |id| filenames[id] }.join(', ')};\n"
      end

      ##
      # @private
      # @return [String]
      def exists_notice(exists, filenames)
        'Files already uploaded, new version is ignored: ' \
        "#{exists.map { |id| filenames[id] }.join(', ')}"
      end
  end
end
