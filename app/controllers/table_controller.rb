class TableController < ApplicationController
  def index
    if current_user && current_user.role?('Методолог')
      redirect_to :test_groups
    elsif current_user && current_user.role?('Регистратор')
      redirect_to :doctors
    end
  end
end