class AddSectionToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :section_id, :integer
    add_index :tasks, :section_id
  end
end
