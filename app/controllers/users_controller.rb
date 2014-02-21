require 'pry-debugger'

class UsersController < ApplicationController
  before_filter :require_login, except: [:new, :create, :verify]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    stormpath_account = StormpathConfig.application.accounts.create({
      given_name: params[:given_name],
      surname: params[:surname],
      email: params[:email],
      username: params[:username],
      password: params[:password]
    })

    @user = User.new({ stormpath_url: stormpath_account.href})

    flash[:message] = "Your account has been created. Depending on how you've configured your directory, you may need to check your email and verify the account before logging in."
    redirect_to new_session_path
  rescue Stormpath::Error => error
    flash[:notice] = error.message
    render :new
  end

  def edit
    @user = User.find(params[:id])
    @user_groups = @user.stormpath_account.groups
  end

  def update
    @user = User.find(params[:id])

    account = @user.stormpath_account
    account.given_name = params[:given_name]
    account.surname = params[:surname]
    account.email = params[:email]
    account.custom_data[:favorite_color] = params[:custom_data][:favorite_color]
    account.save

    flash[:message] = "The account has been updated successfully."
    redirect_to users_path

    render :edit
  end

  def destroy
    @user = User.find(params[:id])
    if @user != current_user
      @user.stormpath_account.delete
      @user.destroy
    else
      flash[:message] = "You can not delete your own account!"
    end
    redirect_to users_path
  end

  def verify
    begin
      User.verify_account_email params[:sptoken]
      flash[:message] = 'Your account has been verified. Please log in using your username and password'
    rescue Stormpath::Error => error
      flash[:message] = error.message
    end

    redirect_to new_session_path
  end

end
