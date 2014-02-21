require 'pry'
require 'pry-debugger'

class ApplicationController < ActionController::Base
  protect_from_forgery

  ADMIN_GROUP_NAME = "Admins"

  helper_method :logged_in?, :current_user, :is_admin?, :not_admin?

  def redirect_unless_admin
    redirect_to root_path unless is_admin?
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.where(id: session[:user_id]).first
    end
  end

  def error_message_for resource
    resource.errors[:base].join ' '
  end

  def is_admin?
    if current_user
      @is_admin =  current_user.stormpath_account.groups.map(&:name).include? ADMIN_GROUP_NAME
    end
  end

  def not_admin?
    !is_admin?
  end

  def logged_in?
    !!current_user
  end

  def require_not_logged_in
    redirect_to root_path if logged_in?
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end


end
