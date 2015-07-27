class AddColumnToTry < ActiveRecord::Migration
  def change
    add_column :tries, :assigned_test_id, :integer
  end
end
