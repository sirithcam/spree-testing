# frozen_string_literal: true

Capybara.default_driver = ENV['BROWSER'].to_sym

Capybara.app_host = ENV['APP_HOST']
