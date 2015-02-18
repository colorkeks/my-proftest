class CreateTaskResults < ActiveRecord::Migration
  def change
    create_table :task_results do |t|
      t.float :point
      t.text :text
      t.string :status
      t.integer :task_id
      t.integer :try_id

      t.timestamps
    end
  end
end
