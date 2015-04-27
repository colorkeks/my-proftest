class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.boolean :attestation , default: false
      t.string :algorithm
      t.integer :percent_tasks
      t.string :title
      t.time :timer
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
