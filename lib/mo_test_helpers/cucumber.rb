require 'rspec/expectations'
require "watir-webdriver"
require 'capybara'
require "selenium-webdriver"
require 'pp'
require 'mo_test_helpers/selenium_helper'

puts "Running with engine: #{MoTestHelpers.engine}"
puts "Running in CI: #{ENV['CI']}"

# Validate the browser
MoTestHelpers::SeleniumHelper.validate_browser!

# see if we are running on MO CI Server
if ENV['CI'] == "true" and ENV['SELENIUM_GRID_URL'] != ""
  puts "Running Cucumber in CI Mode."
  
  if MoTestHelpers.engine == :capybara
    raise ArgumentError.new('Please give the URL to the Rails Server!') if ENV['URL'].blank?
    
    Capybara.app_host = ENV['URL']
    Capybara.register_driver :selenium do |app|
      MoTestHelpers::SeleniumHelper.grid_capybara_browser(app)
    end
  else
    browser = MoTestHelpers::SeleniumHelper.grid_watir_browser
  end
else
  if MoTestHelpers.engine == :capybara
    Capybara.register_driver :selenium do |app|
      MoTestHelpers::SeleniumHelper.capybara_browser(app)
    end
  else
    browser = MoTestHelpers::SeleniumHelper.watir_browser
  end
end

if MoTestHelpers.engine == :capybara
  Capybara.server_port = ENV['SERVER_PORT'] || 3001
end  

# "before all"
Before do
  if MoTestHelpers.engine == :watir
    puts "Running Watir Browser."
    
    @browser = browser
    raise ArgumentError.new('Please give the URL to the Rails Server!') if ENV['URL'].blank?
    @base_url = ENV['URL']
    @browser.goto ENV['URL']
  end
end

# "after all"
at_exit do
  if @browser
    puts "Closing Watir browser."
    @browser.close unless ENV["STAY_OPEN"]
  end
end

# should we run headless? Careful, CI does this alone!
if ENV['HEADLESS'] == 'true' and ENV['CI'] != "true"
  require 'headless'
  puts "Starting headless..."
  
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end