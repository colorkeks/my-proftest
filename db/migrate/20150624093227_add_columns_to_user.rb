class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :drcode , :string
  end
end
