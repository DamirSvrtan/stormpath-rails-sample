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
    begin
    # stormpath_account = Stormpath::Rails.application.accounts.create({
    #   given_name: params[:user][:given_name],
    #   surname: params[:user][:surname],
    #   email: params[:user][:email],
    #   username: params[:user][:username],
    #   password: params[:user][:password]
    # })

      @user = User.new(user_params)
      if @user.save
        flash[:message] = "Your account has been created. Depending on how you've configured your directory, you may need to check your email and verify the account before logging in."
        redirect_to new_session_path
      else
        flash[:notice] = @user.errors
        render :new  
      end
    rescue Stormpath::Error => error
      flash[:notice] = error.message
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @user_groups = @user.stormpath_account.groups
  end

  def update
    begin
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
      @user_groups = @user.stormpath_account.groups
      # account = @user.stormpath_account
      # account.given_name = params[:user][:given_name]
      # account.surname = params[:user][:surname]
      # account.username = params[:user][:username]
      # account.email = params[:user][:email]
      # account.custom_data[:favorite_color] = params[:user][:favorite_color]
      # account.save
      # binding.pry
      if @user.save
        flash[:message] = "The account has been updated successfully."
        redirect_to users_path
      else
        flash[:notice] = @user.errors
        render :new  
      end
    rescue Stormpath::Error => e
      flash[:message] = e.message
      @user_groups = @user.stormpath_account.groups
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user != current_user
      # @user.stormpath_account.delete
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

  private

    def user_params
      params.require(:user).permit(:given_name, :surname, :username, :email, :favorite_color, :password)
    end

end
