class CreateTemplateUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :template_updates do |t|
      t.string :behavior
      t.text   :ids
      t.string :template_name
      t.timestamps
    end
  end
end
