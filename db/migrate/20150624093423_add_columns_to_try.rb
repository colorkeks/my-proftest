class AddColumnsToTry < ActiveRecord::Migration
  def change
    add_column :tries, :test_mode_id, :integer
  end
end
