require 'selenium/webdriver'

module MoTestHelpers

  class SeleniumHelper

    BROWSERS = [
      "firefox", "android", "chrome", "htmlunit", "internet explorer", "ipad", "iphone", "opera", "safari"
    ]

    GRID_OPTIONS = %w{
      platform javascript_enabled css_selectors_enabled rotatable firefox_profile browser_version
    }

    class << self

      def validate_browser!
        raise ArgumentError.new("The browser #{browser} is not supported.") unless BROWSERS.include?(browser)
      end

      def capabilities
        capability_opts = {}
        GRID_OPTIONS.each do |opt|
          if opt == "browser_version"
            capability_opts[:version] = ENV[opt.to_s.upcase] if ENV[opt.to_s.upcase]
          else
            capability_opts[opt.to_sym] = ENV[opt.to_s.upcase] if ENV[opt.to_s.upcase]
          end
        end

        eval("@capabilities = Selenium::WebDriver::Remote::Capabilities.#{browser.gsub(' ', '_')}(capability_opts)")

        puts "Loading Browser: #{browser}"
        puts "with capabilities"
        pp @capabilities

        return @capabilities
      end

      def watir_browser
        if ENV['USER_AGENT']
          driver = UserAgent.driver(
            :browser => browser, 
            :agent => (ENV['USER_AGENT'] || :iphone), 
            :orientation => (ENV['orientation'] || :portrait)
          )
          
          Watir::Browser.new(driver)
        else
          Watir::Browser.new(browser)
        end
      end

      def capybara_browser(app)
        Capybara::Selenium::Driver.new(app, :browser => browser.to_sym)
      end

      def grid_watir_browser
        raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") unless selenium_grid
        
        browser = Watir::Browser.new(:remote, :url => selenium_grid, :desired_capabilities => capabilities, :http_client => http_client)
        browser.driver.manage.timeouts.implicit_wait = 30

        return browser
      end

      def grid_capybara_browser(app)
        raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") unless selenium_grid

        browser = Capybara::Selenium::Driver.new(app,
          :browser => :remote,
          :url => selenium_grid,
          :desired_capabilities => capabilities,
          :http_client => http_client
        )

        return browser
      end

      def grid_selenium_browser
        raise ArgumentError.new("SELENIUM_GRID_URL has to be defined.") unless selenium_grid

        browser = Selenium::WebDriver.for(:remote,
          :url => selenium_grid,
          :desired_capabilities => capabilities,
          :http_client => http_client
        )
        browser.manage.timeouts.implicit_wait = 30

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

end