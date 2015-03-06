class CreateTaskContents < ActiveRecord::Migration
  def change
    create_table :task_contents do |t|
      t.attachment :file_content
      t.integer :task_id
      t.timestamps
    end
  end
end
