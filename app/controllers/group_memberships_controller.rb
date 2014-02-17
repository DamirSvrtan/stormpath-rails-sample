class GroupMembershipsController < ApplicationController

  before_action :redirect_unless_admin

  before_action { @user = User.find(params[:user_id]) }

  def show
    @users_groups = @user.stormpath_account.groups
    @application_groups = Stormpath::Rails::Client.application.groups
  end

  def create
    group = Stormpath::Rails::Client.application.groups.get params[:group_href]
    account = @user.stormpath_account
    Stormpath::Rails::Client.client.group_memberships.create group: group, account: account
    redirect_to action: :show
  end

  def destroy
    group = Stormpath::Rails::Client.application.groups.get params[:group_href]
    account = @user.stormpath_account
    account.group_memberships.each do |group_membership|
      group_membership.delete if group_membership.group.href == group.href
    end
    redirect_to action: :show
  end

end