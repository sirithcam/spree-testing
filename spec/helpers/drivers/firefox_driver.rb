# frozen_string_literal: true

require './spec/helpers/driver_helper.rb'

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless' if ENV.fetch('HEADLESS', '1') == '1'

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    driver_path: path_to_driver('geckodriver'),
    options: options
  )
end
