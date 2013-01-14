require 'rspec/expectations'
require "watir-webdriver"
require "selenium-webdriver"
require 'pp'
require 'selenium_helper'

# Validate the browser
SeleniumHelper.validate_browser!

# see if we are running on MO CI Server
if ENV['CI'] == "true"
  puts "Running Cucumber in CI Mode."

  browser = SeleniumHelper.grid_watir_browser
else
  browser = SeleniumHelper.watir_browser
end

# "before all"
Before do
  @browser = browser
  raise ArgumentError.new('Please give the URL to the Rails Server!') if ENV['URL'].blank?
  @base_url = ENV['URL']
  @browser.goto ENV['URL']
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