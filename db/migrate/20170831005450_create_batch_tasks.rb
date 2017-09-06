class CreateBatchTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :batch_tasks do |t|
      t.string :batch_type
      t.timestamps
    end
  end
end
