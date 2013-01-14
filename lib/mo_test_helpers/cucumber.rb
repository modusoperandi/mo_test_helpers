require 'rspec/expectations'
require "watir-webdriver"
require 'capybara'
require "selenium-webdriver"
require 'pp'
require 'mo_test_helpers/selenium_helper'

# Validate the browser
MoTestHelpers::SeleniumHelper.validate_browser!

# see if we are running on MO CI Server
if ENV['CI'] == "true"
  puts "Running Cucumber in CI Mode."
  
  if ENGINE and ENGINE = :capybara
    Capybara.register_driver :selenium do |app|
      MoTestHelpers::SeleniumHelper.grid_capybara_browser(app)
    end
  else
    browser = MoTestHelpers::SeleniumHelper.grid_watir_browser
  end
else
  if ENGINE and ENGINE = :capybara
    Capybara.register_driver :selenium do |app|
      MoTestHelpers::SeleniumHelper.capybara_browser(app)
    end
  else
    browser = MoTestHelpers::SeleniumHelper.watir_browser
  end
end

# "before all"
Before do
  unless ENGINE and ENGINE = :capybara
    @browser = browser
    raise ArgumentError.new('Please give the URL to the Rails Server!') if ENV['URL'].blank?
    @base_url = ENV['URL']
    @browser.goto ENV['URL']
  end
end

# "after all"
at_exit do
  @browser.close unless ENV["STAY_OPEN"]
end

# should we run headless? Careful, CI does this alone!
if ENV['HEADLESS'] == 'true' and not ENV['CI'].present?
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end