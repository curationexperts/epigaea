class CreateMetadataExports < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata_exports do |t|
      t.string :filename
      t.timestamps
    end
  end
end
