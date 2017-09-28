##
# A job that prepares a metadata export for a batch.
#
# This job takes a list of ids for Works and produces a metadata download file.
class MetadataExportJob < BatchableJob
  def perform(export)
    exporter = Tufts::MetadataExporter.new(ids:  export.object_ids,
                                           name: "xml_export-#{export.id}")
    exporter.export!

    export.filename = exporter.filename
    export.save!
  end
end
