class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :test_id
      t.string :name

      t.timestamps null: false
    end
    add_index :sections, :test_id
  end
end