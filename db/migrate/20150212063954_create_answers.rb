class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean :correct
      t.text :text
      t.integer :point
      t.integer :task_id

      t.timestamps
    end
  end
end
