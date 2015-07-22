class TableController < ApplicationController
  def index
      if current_user && current_user.priority_role.name == 'Регистратор'
        redirect_to :doctors
      elsif current_user && current_user.priority_role.name == 'Методолог'
        redirect_to :test_groups
      elsif current_user && current_user.priority_role.name == 'Тестируемый'
        redirect_to testee_tab_users_path
      end
  end
end