class AccountStoreMappingsController < ApplicationController
  
  before_action :redirect_unless_admin

  def show
    @directories = Stormpath::Rails::Client.client.directories
    @account_stores = Stormpath::Rails::Client.application.account_store_mappings.map(&:account_store)
  end

  def create
    directory = Stormpath::Rails::Client.client.directories.get params[:href]
    application = Stormpath::Rails::Client.application
    Stormpath::Rails::Client.client.account_store_mappings.create(application: application, account_store: directory)
    redirect_to action: :show
  end

  def destroy
    directory = Stormpath::Rails::Client.client.directories.get params[:href]
    Stormpath::Rails::Client.application.account_store_mappings.each do |account_store_mapping|
       account_store_mapping.delete if account_store_mapping.account_store.href == directory.href
    end
    redirect_to action: :show
  end

end