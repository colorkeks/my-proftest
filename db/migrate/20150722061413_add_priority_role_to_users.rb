class AddPriorityRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :priority_role_id, :string
  end
end
