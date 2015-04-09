class AddDefaultValueToTry < ActiveRecord::Migration
  def up
    change_column :tries, :status, :string, :default => 'Не выполнен'
  end

  def down
    change_column :tries, :correct, :string, :default => nil
  end
end
