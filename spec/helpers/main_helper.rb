# frozen_string_literal: true

module MainHelper
  def wait_for(options = {})
    default_options = {
      error: nil,
      seconds: 5
    }.merge(options)

    Selenium::WebDriver::Wait.new(timeout: default_options[:seconds]).until { yield }
  rescue Selenium::WebDriver::Error::TimeOutError
    default_options[:error].nil? ? false : raise(error)
  end

  def scroll_to_bottom
    page.execute_script 'window.scrollBy(0,10000)'
  end

  def scroll_to_top
    page.execute_script 'window.scrollTo(0,0)'
  end

  def scroll_to(element)
    Capybara.current_session.driver.browser.execute_script('arguments[0].scrollIntoView(true);', element.native)
  end

  def login_as_admin
    visit Router.new.login_path
    fill_in 'Email', with: ENV['ADMIN_LOGIN']
    fill_in 'Password', with: ENV['ADMIN_PASSWORD']
    find('.btn-lg').click
  end
end
