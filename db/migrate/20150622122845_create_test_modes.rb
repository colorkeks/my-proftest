class CreateTestModes < ActiveRecord::Migration
  def change
    create_table :test_modes do |t|
      t.date :date_beg
      t.date :date_end
      t.string :name
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
