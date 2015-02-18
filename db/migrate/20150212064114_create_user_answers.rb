class CreateUserAnswers < ActiveRecord::Migration
  def change
    create_table :user_answers do |t|
      t.boolean :user_reply
      t.boolean :correct
      t.text :text
      t.integer :point
      t.integer :task_id
      t.integer :task_result_id

      t.timestamps
    end
  end
end
