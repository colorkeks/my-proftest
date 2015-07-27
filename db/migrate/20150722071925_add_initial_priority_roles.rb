class AddInitialPriorityRoles < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.priority_role_id.blank?
        user.priority_role_id = user.roles.first.id
        user.save!
      end
    end
  end
end
