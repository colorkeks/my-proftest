class TableController < ApplicationController
  def index
      if current_user && current_user.roles.find(current_user.priority_role_id).name == 'Администратор'
        redirect_to :doctors
      elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Регистратор'
        redirect_to :doctors
      elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Методолог'
        redirect_to :test_groups
      elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Тестируемый'
        redirect_to testee_tab_users_path
      end
  end
end