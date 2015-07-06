class CreateTryTaskContents < ActiveRecord::Migration
  def change
    create_table :try_task_contents do |t|
      t.integer :task_result_id
      t.integer :task_content_version_id

      t.timestamps null: false
    end
    add_index :try_task_contents, :task_result_id
  end
end
