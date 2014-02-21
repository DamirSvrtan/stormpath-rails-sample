class GroupMembershipsController < ApplicationController

  before_action :redirect_unless_admin

  before_action { @user = User.find(params[:user_id]) }

  def show
    @users_groups = @user.stormpath_account.groups
    @application_groups = StormpathConfig.application.groups
  end

  def create
    group = StormpathConfig.application.groups.get params[:group_href]
    account = @user.stormpath_account
    StormpathConfig.client.group_memberships.create group: group, account: account
    redirect_to action: :show
  end

  def destroy
    group = StormpathConfig.application.groups.get params[:group_href]
    account = @user.stormpath_account
    account.group_memberships.each do |group_membership|
      group_membership.delete if group_membership.group.href == group.href
    end
    redirect_to action: :show
  end

end