require 'dotenv/load'
require 'capybara_helper'
require 'pry'
require 'faker'

# Add helpers to all Specs
Dir['./spec/helpers/**/*.rb'].each { |file| require file }
Dir['./spec/shared_examples/**/*.rb'].each { |file| require file }

ENV['browser'] ||= 'chrome'
Capybara.default_driver = ENV['browser'].to_sym

ENV['env'] ||= 'staging'
Capybara.app_host = case ENV['env']
                    when 'staging'
                      'https://example-staging.com'
                    when 'production'
                      'https://example.com'
                    end 

Capybara.run_server = false

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include MainHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after { Capybara.reset_sessions! }
end
