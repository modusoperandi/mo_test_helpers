require 'mo_test_helpers'
require 'rspec/expectations'
require "watir-webdriver"
require 'capybara'
require "selenium-webdriver"
require 'pp'
require 'mo_test_helpers/selenium_helper'

module MoTestHelpers
  
  class Cucumber
    
    class << self
      attr_accessor :engine
    
      def configure
        yield self
      end
    end
    
    attr_accessor :browser
    
    def initialize
      
    end
    
    def run
      start_headless!
      MoTestHelpers::SeleniumHelper.validate_browser!
      
      if grid?
        debug "Running cucumber in the grid with #{self.class.engine}."
        run_grid_cucumber
      else
        debug "Running cucumber locally with #{self.class.engine}."
        run_local_cucumber
      end
    end
    
    def run_grid_cucumber
      if self.class.engine == :capybara
        Capybara.app_host = test_url
        Capybara.register_driver :selenium do |app|
          SeleniumHelper.grid_capybara_browser(app)
        end
      elsif self.class.engine == :watir
        browser = SeleniumHelper.grid_watir_browser
      end
    end
    
    def run_local_cucumber
      if MoTestHelpers::Cucumber.engine == :capybara
        Capybara.register_driver :selenium do |app|
          MoTestHelpers::SeleniumHelper.capybara_browser(app)
        end
        
        Capybara.server_port = local_server_port
      else
        browser = MoTestHelpers::SeleniumHelper.watir_browser
      end
    end
    
    def start_headless!
      return if headless? and not ci?
      debug "Starting headless..."
      
      require 'headless'

      headless = Headless.new
      headless.start
      at_exit do
        headless.destroy
      end
    end
    
    def debug(msg)
      pp msg if debugging?
    end
    
    def local_server_port
      ENV['SERVER_PORT'] || 3001
    end
    
    def test_url
      ENV['URL'] || "http://localhost:3000/"
    end
    
    def ci?
      ENV['CI'] == "true"
    end
    
    def headless?
      ENV['HEADLESS'] == "true"
    end
    
    def debugging?
      ENV['DEBUG'] == "1"
    end
    
    def grid?
      ENV['SELENIUM_GRID_URL'].to_s != ""
    end
    
    def stay_open?
      ENV['STAY_OPEN'] == "true"
    end
    
  end
  
end

MoTestHelpers::Cucumber.configure do |config|
  config.engine = :watir
end

@runner = MoTestHelpers::Cucumber.new

@runner.debug "Running with engine: #{MoTestHelpers::Cucumber.engine}"
@runner.debug "Running in CI: #{@runner.ci?}"
@runner.debug "Running Headless: #{@runner.headless?}"

@runner.run

# "before all"
Before do
  if MoTestHelpers::Cucumber.engine == :watir
    @browser    = @runner.browser
    @base_url   = @runner.test_url
    @browser.goto @runner.test_url
  end
end

# "after all"
at_exit do
  if @runner.browser
    puts "Closing Watir browser."
    @browser.close unless @runner.stay_open?
  end
end