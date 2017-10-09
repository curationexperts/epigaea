class CreateMetadataImports < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata_imports do |t|
      t.string :metadata_file
      t.timestamps
    end
  end
end
