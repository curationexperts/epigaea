class CreateXmlImports < ActiveRecord::Migration[5.0]
  def change
    create_table :xml_imports do |t|
      t.string :metadata_file
      t.text   :uploaded_file_ids
      t.timestamps
    end
  end
end
