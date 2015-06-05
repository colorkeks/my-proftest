class DoctorsDbf < ActiveRecord::Migration
  def change
    create_table :doctor_dbfs do |t|
      t.column "drcode", :string, :limit => 8
      t.column "dbsource", :string, :limit => 1
      t.column "lpuwork", :integer
      t.column "surname", :string, :limit => 24
      t.column "name", :string, :limit => 16
      t.column "secname", :string, :limit => 16
      t.column "pension", :string, :limit => 14
      t.column "datebeg", :date
      t.column "dateend", :date

    end

    add_index :doctor_dbfs, :drcode
  end
end
