##
# A job to process imported records and files
class ImportJob < BatchableJob
  def perform(import_record, file); end # no-op
end
