class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.text :text
      t.integer :serial_number
      t.integer :task_id
      t.timestamps
    end
  end
end
