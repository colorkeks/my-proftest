class AddPriorityRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :priority_role_id, :string
    User.reset_column_information
    User.all.each do |user|
      if user.priority_role.blank?
        user.priority_role_id = user.roles.first.id
        user.save!
      end
    end
  end
end
