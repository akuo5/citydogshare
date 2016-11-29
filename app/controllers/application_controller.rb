class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_uid(session[:user_id]) if session[:user_id]
    @is_admin = Admin.is_admin?(@current_user)
    return @current_user
  end
  helper_method :current_user

end
