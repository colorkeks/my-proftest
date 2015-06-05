class LpuDbf < ActiveRecord::Migration
  def change
    create_table :lpu_dbfs do |t|
      t.column "lpucode", :integer
      t.column "type_s", :integer
      t.column "name", :string, :limit => 128
      t.column "name_l", :string, :limit => 254
      t.column "name_s", :string, :limit => 60
      t.column "oms", :integer
      t.column "pmsp_yes", :integer
      t.column "dent_yes", :integer
      t.column "age", :integer
      t.column "index", :string, :limit => 6
      t.column "ter", :integer
      t.column "orgn1", :integer
      t.column "orgn2", :integer
      t.column "orgn3", :integer
      t.column "razdel", :integer
      t.column "street", :integer
      t.column "house", :integer
      t.column "houseliter", :string, :limit => 1
      t.column "corpus", :integer
      t.column "flat", :integer
      t.column "flatliter", :string, :limit => 1
      t.column "e_mail", :string, :limit => 64
      t.column "npost", :string, :limit => 40
      t.column "face", :string, :limit => 48
      t.column "phone", :string
      t.column "fax", :string
      t.column "face1", :string, :limit => 48
      t.column "phone1", :string
      t.column "npost3", :string, :limit => 40
      t.column "face3", :string, :limit => 48
      t.column "e_mail3", :string, :limit => 64
      t.column "phone3", :string
      t.column "inn", :string, :limit => 12
      t.column "ogrn", :string, :limit => 15
      t.column "owercode", :integer
      t.column "nn_lpu", :string, :limit => 12
      t.column "domain", :integer
      t.column "chief", :integer
      t.column "kopf", :integer
      t.column "ekatc", :string, :limit => 8
      t.column "okpo", :string, :limit => 13
      t.column "soato", :string
      t.column "soogu", :string
      t.column "kpp", :string, :limit => 9
      t.column "datebeg", :date
      t.column "dateend", :date
      t.column "datemod", :date

    end

    add_index :lpu_dbfs, :lpucode
  end
end
