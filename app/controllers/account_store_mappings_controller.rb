class AccountStoreMappingsController < ApplicationController
  
  before_action :redirect_unless_admin

  def show
    @directories = StormpathConfig.client.directories
    @account_stores = StormpathConfig.application.account_store_mappings.map(&:account_store)
  end

  def create
    directory = StormpathConfig.client.directories.get params[:href]
    application = StormpathConfig.application
    StormpathConfig.client.account_store_mappings.create(application: application, account_store: directory)
    redirect_to action: :show
  end

  def destroy
    directory = StormpathConfig.client.directories.get params[:href]
    StormpathConfig.application.account_store_mappings.each do |account_store_mapping|
       account_store_mapping.delete if account_store_mapping.account_store.href == directory.href
    end
    redirect_to action: :show
  end

end