class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to current_user , :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if (current_user.first_name.nil? || current_user.first_name.nil? || current_user.first_name.nil?)
      edit_user_path(current_user.id)
    else
      current_user
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    table_index_path
  end
end
