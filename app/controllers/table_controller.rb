class TableController < ApplicationController
  def index
    # if current_user && current_user.role?('Регистратор')
    #   redirect_to :doctors
    # elsif current_user && current_user.role?('Методолог')
    #   redirect_to :test_groups
    # elsif current_user && current_user.role?('Тестируемый')
    #   redirect_to testee_tab_users_path
    # end
  end
end