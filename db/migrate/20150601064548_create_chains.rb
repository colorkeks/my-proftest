class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.integer :test_id, null: false
      t.integer :section_id
      t.integer :eqvgroup_id, null: false

      t.timestamps null: false
    end
    add_index :chains, :test_id

    add_column :tasks, :chain_id, :integer
    add_column :tasks, :chain_position, :integer
    add_index :tasks, [:chain_id, :chain_position], unique: true
  end
end
