# frozen_string_literal: true

module MainHelper
  def wait_for(options = {})
    default_options = {
      error: nil,
      seconds: 5
    }.merge(options)

    Selenium::WebDriver::Wait.new(timeout: default_options[:seconds]).until { yield }
  rescue Selenium::WebDriver::Error::TimeOutError
    default_options[:error].nil? ? false : raise(default_options[:error])
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

    wait_for(error: 'Not logged in.') { page.has_css?('.alert-success', text: 'Logged in successfully') }
  end

  def logout
    visit Router.new.logout_path
    wait_for(error: 'Not logged out.') { page.has_css?('.alert-notice', text: 'Signed out successfully.') }
  end

  def visit_product(slug)
    visit "#{Router.new.products_path}/#{slug}"
  end

  def image_name(object)
    object[:src].split('/').last
  end

  def image_names(objects)
    objects.map { |image| image_name(image) }
  end

  def click_unactive_pagination
    all('.pagination .page').reject { |page| page[:class].include? 'active' }.sample.find('a').click
  end

  def convert_to_float(object)
    object.text.delete('-$').to_f
  end
end
