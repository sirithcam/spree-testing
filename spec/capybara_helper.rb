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

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new()
  options.args << '--headless' if ENV.fetch('HEADLESS', '1') == '1'

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.default_driver = ENV.fetch('BROWSER', 'chrome').to_sym

Capybara.app_host = case ENV.fetch('ENV', 'staging')
                    when 'staging'
                      ENV['APP_HOST_STAGING']
                    when 'production'
                      ENV['APP_HOST_PRODUCTION']
                    end
