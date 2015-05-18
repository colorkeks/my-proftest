class CreateTestGroups < ActiveRecord::Migration
  def change
    create_table :test_groups do |t|
      t.string :name
      t.integer :parent_id, :null => true
      t.integer :lft, :null => false
      t.integer :rgt, :null => false

      # optional fields
      t.integer :depth, :null => false, :default => 0
      #t.integer :children_count, :null => false, :default => 0

      t.timestamps null: false
    end
    add_index :test_groups, :parent_id
    add_index :test_groups, :lft
    add_index :test_groups, :rgt

    tg = TestGroup.find_or_initialize_by(name: 'Тесты')
    tg.save!
  end

end
