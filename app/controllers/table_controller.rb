class TableController < ApplicationController
  def index
    if current_user && current_user.role?('Методолог')
      redirect_to :test_groups
    end
  end
end