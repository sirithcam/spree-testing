desired_android_caps = {
  browserName:     'Chrome',
  deviceName:      '5.0.1',
  platformName:    'Android',
  automationName:  'UiAutomator2',
  platformVersion: '5.0.1'
}

url = 'http://localhost:4723/wd/hub'

Capybara.register_driver(:android) do |app|
  appium_lib_options = { 
    server_url: url 
  }   

  all_options = { 
    appium_lib:  appium_lib_options,
    caps:        desired_android_caps
  }   

  Appium::Capybara::Driver.new app, all_options
end
