class DirectoriesController < ApplicationController

  before_action :redirect_unless_admin

  def show
    @directory = Stormpath::Rails::Client.client.directories.get params[:href]
    @directory_groups = @directory.groups
  end

end