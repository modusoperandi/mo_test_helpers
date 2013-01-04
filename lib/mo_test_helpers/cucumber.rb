require 'rspec/expectations'
require "watir-webdriver"
require 'pp'

BROWSERS = %w{
  android chrome firefox htmlunit internet_explorer ipad iphone opera safari
}

GRID_OPTIONS = %w{
  platform version javascript_enabled css_selectors_enabled rotatable firefox_profile
}

# Validate the browser
env_browser = ENV['BROWSER'] || 'firefox'
raise ArgumentError.new("The browser #{env_browser} is not supported.") unless BROWSERS.include?(env_browser)

# see if we are running on MO CI Server
if ENV['CI'] == "true"
  puts "Running Cucumber in CI Mode."
  # check if we have the grid
  selenium_grid = ENV['SELENIUM_GRID_URL']
  
  raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") if selenium_grid.blank?
  
  capability_opts = {}
  GRID_OPTIONS.each do |opt|
    capability_opts[opt.to_sym] = ENV[opt.to_s.upcase] if ENV[opt.to_s.upcase].present?
  end
  
  eval("capabilities = WebDriver::Remote::Capabilities.#{env_browser}(capability_opts)")
  
  puts "Loading Browser: #{env_browser}"
  puts "with capabilities"
  pp capabilities
  
  browser = Watir::Browser.new(:remote, :url => selenium_grid, :desired_capabilities => capabilities)
else
  browser = Watir::Browser.new(env_browser)
end

# "before all" 
Before do
  @browser = browser
end

# "after all"
at_exit do
  return if ENV['CI'] == 'true'
  
  unless ENV["STAY_OPEN"]
    browser.close
  end
end