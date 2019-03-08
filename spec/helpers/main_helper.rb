# frozen_string_literal: true

module MainHelper
  def wait_for(options = {})
    default_options = {
      error: nil,
      seconds: 5
    }.merge(options)

    Selenium::WebDriver::Wait.new(timeout: options[:seconds]).until { yield }
  rescue Selenium::WebDriver::Error::TimeOutError
    options[:error].nil? ? false : raise(error)
  end 
end
