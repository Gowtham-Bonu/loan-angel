class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def admin_user
    User.find_by(role: true)
  end
  helper_method :admin_user

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :first_name, :last_name, :phone, :role)}

      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :first_name, :last_name, :phone, :role)}
  end
end
