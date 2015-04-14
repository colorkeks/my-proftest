class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :title
      t.time :timer
      t.string :algoritm
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
