class AddVersionsToTaskResults < ActiveRecord::Migration
  def change
    add_column :task_results, :task_version_id, :integer
    add_column :user_answers, :answer_version_id, :integer
    add_column :user_associations, :association_version_id, :integer
  end
end
