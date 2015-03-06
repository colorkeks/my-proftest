class CreateTaskResults < ActiveRecord::Migration
  def change
    create_table :task_results do |t|
      t.float :point
      t.string :task_type
      t.text :text
      t.text :hint
      t.string :status
      t.integer :task_id
      t.integer :try_id

      t.timestamps
    end
  end
end
