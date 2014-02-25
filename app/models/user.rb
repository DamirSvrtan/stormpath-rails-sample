class User < ActiveRecord::Base
  include Stormpath::Rails::Account
  custom_data_attributes :favorite_color

  # [:given_name, :surname, :password, :email, :middle_name, :username].each do |attribute|
  #   define_method attribute do
  #     self.stormpath_account.send(attribute)
  #   end
  # end

  # [:favorite_color].each do |attribute|
  #   define_method attribute do
  #     self.stormpath_account.custom_data[attribute]
  #   end
  # end

  # def stormpath_account
  #   Stormpath::Rails.application.accounts.get stormpath_url
  # end
end
