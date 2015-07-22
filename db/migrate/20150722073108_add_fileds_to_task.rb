class AddFiledsToTask < ActiveRecord::Migration
  def change
    add_column :tests, :training, :boolean
    add_column :tests, :can_change, :boolean
    add_column :tests, :mix_tasks, :boolean
    add_column :tests, :mix_answers, :boolean
    add_column :tests, :limit_time, :boolean
    remove_column :tests, :timer
    add_column :tests, :timer, :integer
  end
end
