class AddPostDbfs < ActiveRecord::Migration
  def change
    create_table "post_dbfs" do |t|
      t.column "postcode", :integer
      t.column "prvd_131", :integer
      t.column "prvd_53", :integer
      t.column "name", :string, :limit => 64
      t.column "speccode", :integer
      t.column "profcode", :integer
      t.column "actpack", :string, :limit => 3
      t.column "change_r", :integer
      t.column "d_fin", :date
      t.column "d_start", :date
      t.column "d_modif", :date
      t.column "deleted", :integer
    end
  end
end
