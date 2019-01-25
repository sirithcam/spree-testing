# frozen_string_literal: true

Capybara.configure do |config|
  include DriverHelper
  config.default_driver = ENV['BROWSER'].to_sym
  config.app_host = ENV['APP_HOST']
end
