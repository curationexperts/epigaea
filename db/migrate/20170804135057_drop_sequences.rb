class DropSequences < ActiveRecord::Migration[5.0]
  def change
    drop_table :sequences # rubocop:disable Rails/ReversibleMigration
  end
end
