class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.boolean :directory, default: false
      t.boolean :attestation , default: false
      t.string :algorithm
      t.integer :percent_tasks
      t.string :title
      t.time :timer
      t.text :description
      t.integer :user_id


      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
  end
end
