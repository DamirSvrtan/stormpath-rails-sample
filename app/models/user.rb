require 'stormpath-rails'

class User < ActiveRecord::Base
  include Stormpath::Rails::Account

  custom_data_attributes :css_background
end
