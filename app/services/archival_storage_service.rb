class ArchivalStorageService
  attr_reader :object, :file

  def initialize(object, file)
    @object = object
    @file = file
  end

  def run
    fs = FileSet.new
    Hydra::Works::UploadFileToFileSet.call(fs, @file)
    @object.file_sets << fs
    @object.save
  end
end
