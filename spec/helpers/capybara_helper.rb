# frozen_string_literal: true

Capybara.configure do |config|
  include DriverHelper

  config.default_driver = ENV['BROWSER'].to_sym

  config.app_host = ENV['APP_HOST']

  config.save_path = 'logs/screenshots'

  if ENV['BROWSER'] == 'ios' || ENV['BROWSER'] == 'android'
    # Default Appium server ip and port
    config.server_host = '0.0.0.0'
    config.server_port = '56844'
  end
end

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
