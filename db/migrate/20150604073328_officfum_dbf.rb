class OfficfumDbf < ActiveRecord::Migration
  def change
    create_table :officfun_dbfs do |t|
      t.column "drcode", :string, :limit => 8
      t.column "lpuwork", :integer
      t.column "speccode", :integer
      t.column "dbsource", :string, :limit => 1
      t.column "postcode", :integer
      t.column "d_prik", :date
      t.column "d_ser", :date
      t.column "category", :integer
      t.column "drstatus", :integer
      t.column "date_b", :date
      t.column "date_e", :date
      t.column "right", :integer
      t.column "actpack", :string, :limit => 3
      t.column "change_r", :integer
      t.column "d_fin", :date
      t.column "d_start", :date
      t.column "d_modif", :date
      t.column "deleted", :integer

    end

    add_index :officfun_dbfs, :drcode
  end
end
