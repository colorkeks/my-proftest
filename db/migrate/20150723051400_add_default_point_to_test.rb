class AddDefaultPointToTest < ActiveRecord::Migration
  def change
    add_column :tests, :default_point, :integer, default: 1
  end
end
