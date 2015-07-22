class AddPriorityRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :priority_role, :string

    User.all.each do |user|
      if user.priority_role.empty?
        user.priority_role.build(name: user.roles.first.name)
        user.save!
      end
    end
  end
end
