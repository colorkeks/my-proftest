class CreateTries < ActiveRecord::Migration
  def change
    create_table :tries do |t|
      t.date :date
      t.float :rate
      t.integer :user_id
      t.integer :test_id

      t.timestamps
    end
  end
end
