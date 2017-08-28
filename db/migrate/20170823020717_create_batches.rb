class CreateBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.references :batchable, polymorphic: true, index: true
      t.belongs_to :user
      t.text       :ids
      t.timestamps
    end
  end
end
