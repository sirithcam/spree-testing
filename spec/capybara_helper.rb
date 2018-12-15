require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        ('headless' if ENV.fetch('HEADLESS', '1') == '1')
      ].compact
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.default_driver = :chrome
Capybara.app_host = ENV['APP_HOST']
