class AddSpeclistDbfs < ActiveRecord::Migration
  def change
    create_table "speclist_dbfs" do |t|
      t.column "speccode", :integer
      t.column "id_spec", :string, :limit => 9
      t.column "id_tfoms", :string, :limit => 9
      t.column "type_spec", :integer
      t.column "name", :string, :limit => 64
      t.column "actpack", :string, :limit => 3
      t.column "change_r", :integer
      t.column "d_fin", :date
      t.column "d_start", :date
      t.column "d_modif", :date
      t.column "deleted", :integer
    end
  end
end
