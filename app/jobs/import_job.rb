##
# A job to process imported records and files
class ImportJob < BatchableJob
  def perform(import, files, id = nil)
    Tufts::ImportService
      .import_object!(files: files, import: import, object_id: id)
  end
end
