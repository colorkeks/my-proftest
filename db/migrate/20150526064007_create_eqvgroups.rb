class CreateEqvgroups < ActiveRecord::Migration
  def change
    create_table :eqvgroups do |t|
      t.integer :test_id, null: false
      t.integer :section_id
      t.integer :number, null: false, default: 1

      t.timestamps null: false
    end
    add_index :eqvgroups, :test_id
    add_index :eqvgroups, :section_id
    add_index :eqvgroups, [:test_id, :number], unique: true
  end
end
