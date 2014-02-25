class GroupsController < ApplicationController 

  before_action :redirect_unless_admin

  def create
    @directory = Stormpath::Rails.client.directories.get params[:directory_href]
    @directory.groups.create name: params[:group_name]
    redirect_to directories_path(href: params[:directory_href])
  end

  def show
    @directory = Stormpath::Rails.client.directories.get params[:directory_href]
    @group = @directory.groups.get params[:href]
    @group_accounts = @group.accounts
    @group_custom_data = @group.custom_data
  end

  def update
    @directory = Stormpath::Rails.client.directories.get params[:directory_href]
    @group = @directory.groups.get params[:href]
    @group.custom_data["view_classified_info"] = params[:view_classified_info]
    @group.custom_data["delete_others"] = params[:delete_others]
    @group.custom_data.save
    redirect_to action: :show, directory_href: params[:directory_href], href: params[:href]
  end

end