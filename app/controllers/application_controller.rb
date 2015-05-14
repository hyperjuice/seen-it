class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :profile_name, :email, :password, :password_confirmation)} 
	end

private 
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action"
    redirect_to(request.referrer || root_path)
  end  
end