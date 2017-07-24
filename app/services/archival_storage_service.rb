class ArchivalStorageService
  attr_reader :object, :dsid, :file

  def initialize(object, dsid, file)
    @object = object
    @dsid = dsid
    @file = file
  end

  def run
    fs = FileSet.new
    Hydra::Works::UploadFileToFileSet.call(fs, @file)
    @object.file_sets << fs
    @object.save
  end

  private

    # If a production object exists and points at this file, then updating the file
    # will invalidate the checksum on the production object. So clear it out.
    def update_production_datastream
      return unless object.draft?
      begin
        published = object.find_published
      rescue ActiveFedora::ObjectNotFoundError
        # Not published yet.
        return
      end
      published.datastreams[dsid].tap do |ds|
        ds.delete
        write_datastream_attributes(ds, path_service.remote_url)
        ds.save
      end
    end

    def write_datastream_attributes(ds, path)
      ds.dsLocation = path
      ds.dsLabel = file.original_filename
      ds.mimeType = file.content_type
      ds.checksum = nil
    end

    # Writes the file to the local datastore
    # @return the remote URL of the file
    def write_file
      path_service.make_directory
      File.open(path_service.local_path, 'wb') do |f|
        f.write file.read
      end
      path_service.remote_url
    end

    def path_service
      @path_service ||= LocalPathService.new(object, dsid, extension)
    end

    def extension
      @extension ||= file.original_filename.split('.').last
    end
end
