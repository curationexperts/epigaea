class AddRecordIdsToXmlImports < ActiveRecord::Migration[5.0]
  def change
    add_column :xml_imports, :record_ids, :text
  end
end
