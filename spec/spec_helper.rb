# frozen_string_literal: true

require 'appium_capybara'
require 'dotenv/load'
require 'pry'
require 'faker'
require 'os'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'

Dir['./spec/helpers/**/*.rb'].each { |file| require file }
Dir['./spec/shared_examples/**/*.rb'].each { |file| require file }
Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include MainHelper
  config.include AdminHelper
  config.include CartHelper

  config.filter_run_excluding block: nil

  config.filter_run_excluding block: nil

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before { Capybara.page.driver.browser.manage.window.resize_to(1340, 1400) }

  config.append_after { Capybara.reset_sessions! }
end
