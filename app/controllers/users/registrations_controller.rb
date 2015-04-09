class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication

  def check_permissions
    authorize! :create, resource
  end
end