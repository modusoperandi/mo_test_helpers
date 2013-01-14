require "selenium-webdriver"
require 'pp'
require 'mo_test_helpers/selenium_helper'

@driver = SeleniumHelper.grid_selenium_browser

unless @driver
  raise ArgumentError.new('Driver not found!')
end