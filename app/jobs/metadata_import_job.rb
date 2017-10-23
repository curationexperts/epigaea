##
# A job that imports metadata to overwrite existing objects.
class MetadataImportJob < BatchableJob
  def perform(import, id)
    Tufts::MetadataImportService.update_object!(import: import, object_id: id)
  end
end
