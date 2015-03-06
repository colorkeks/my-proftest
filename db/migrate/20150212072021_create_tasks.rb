class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :text
      t.text :hint
      t.string :task_type
      t.integer :point
      t.integer :test_id

      t.timestamps
    end
  end
end
