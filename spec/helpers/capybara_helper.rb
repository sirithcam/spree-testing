# frozen_string_literal: true

Capybara.default_driver = ENV['BROWSER'].to_sym

Capybara.app_host = ENV['APP_HOST']

Capybara.save_path = 'logs/screenshots'

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
