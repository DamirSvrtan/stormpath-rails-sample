class SessionsController < ApplicationController
  before_filter :require_login, only: [:destroy]

  def create
    # login_request = Stormpath::Authentication::UsernamePasswordRequest.new params[:username_or_email], params[:password]
    # authentication_result = Stormpath::Rails.application.authenticate_account login_request
    # user = User.find_by stormpath_url: authentication_result.account.href

    user = User.authenticate params[:username_or_email], params[:password]

    session[:user_id] = user.id
    redirect_to users_path
  rescue Stormpath::Error => error
    flash[:notice] = error.message
    render :new
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
