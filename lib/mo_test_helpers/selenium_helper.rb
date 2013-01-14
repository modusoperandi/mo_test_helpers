class SeleniumHelper
  
  BROWSERS = %w{
    firefox android chrome htmlunit internet_explorer ipad iphone opera safari
  }

  GRID_OPTIONS = %w{
    platform javascript_enabled css_selectors_enabled rotatable firefox_profile
  }
  
  class << self
    
    def validate_browser!
      raise ArgumentError.new("The browser #{env_browser} is not supported.") unless BROWSERS.include?(browser)
    end
    
    def capabilities
      capability_opts = {}
      GRID_OPTIONS.each do |opt|
        capability_opts[opt.to_sym] = ENV[opt.to_s.upcase] if ENV[opt.to_s.upcase].present?
      end

      eval("@capabilities = Selenium::WebDriver::Remote::Capabilities.#{browser}(capability_opts)")
      
      puts "Loading Browser: #{browser}"
      puts "with capabilities"
      pp @capabilities
      
      return @capabilities
    end
    
    def watir_browser
      Watir::Browser.new(browser)
    end
    
    def grid_watir_browser
      raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") if selenium_grid.blank?
      
      browser = Watir::Browser.new(:remote, :url => selenium_grid, :desired_capabilities => capabilities, :http_client => http_client)
      browser.driver.manage.timeouts.implicit_wait = 30
      
      return browser
    end
    
    def grid_selenium_browser
      raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") if selenium_grid.blank?
      
      browser = Selenium::WebDriver.for(:remote, 
        :url => selenium_grid, 
        :desired_capabilities => capabilities, 
        :http_client => http_client
      )
      browser.manage.timeouts.implicit_wait = 3
      
      return browser
    end
    
    private
    
    def browser
      ENV['BROWSER'] || BROWSERS.first
    end
    
    def selenium_grid
      ENV['SELENIUM_GRID_URL']
    end
    
    def http_client
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 180
      return client
    end
    
  end
  
end