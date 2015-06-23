class CreateTries < ActiveRecord::Migration
  def change
    create_table :tries do |t|
      t.date :date
      t.float :rate
      t.string :status
      t.time :timer
      t.text 'task_results_queue'
      t.integer :user_id
      t.integer :test_id
      t.integer :test_mode_id

      t.timestamps
    end
  end
end
