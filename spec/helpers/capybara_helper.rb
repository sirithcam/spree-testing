# frozen_string_literal: true

Capybara.configure do |config|
  include DriverHelper

  config.default_driver = ENV['BROWSER'].to_sym

  config.app_host = ENV['APP_HOST']

  config.save_path = 'logs/screenshots'
end

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
