class CreateAssignedTests < ActiveRecord::Migration
  def change
    create_table :assigned_tests do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :test_mode_id

      t.timestamps null: false
    end
  end
end
