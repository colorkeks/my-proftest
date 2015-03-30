class CreateUserAssociations < ActiveRecord::Migration
  def change
    create_table :user_associations do |t|
      t.text :text
      t.integer :serial_number
      t.integer :task_id
      t.integer :association_id
      t.integer :task_result_id
      t.integer :user_answer_id
      t.timestamps
    end
  end
end
