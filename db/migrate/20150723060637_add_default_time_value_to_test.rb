class AddDefaultTimeValueToTest < ActiveRecord::Migration
  def change
    change_column :tests, :timer, :integer, default: 60
  end
end
