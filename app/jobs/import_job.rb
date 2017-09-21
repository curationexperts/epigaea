##
# A job to process imported records and files
class ImportJob < BatchableJob
  def perform(import, file)
    Tufts::ImportService.import_object!(file: file, import: import)
  end
end
