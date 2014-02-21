class User < ActiveRecord::Base
  # include Stormpath::Rails::Account
  # custom_data_attributes :css_background

  [:given_name, :surname, :password, :email, :middle_name, :username].each do |attribute|
    define_method attribute do
      self.stormpath_account.send(attribute)
    end
  end

  def stormpath_account
    StormpathConfig.application.accounts.get stormpath_url
  end
end
