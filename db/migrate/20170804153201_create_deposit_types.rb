class CreateDepositTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :deposit_types do |t|
      t.string :display_name
      t.text :deposit_agreement
      t.datetime :created_at
      t.datetime :updated_at
      t.string :deposit_view
      t.string :license_name
    end
  end
end
