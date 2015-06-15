class AddIndexes < ActiveRecord::Migration
  def change
    add_index :doctor_dbfs, :name
    add_index :doctor_dbfs, :secname
    add_index :doctor_dbfs, :surname
  end
end
