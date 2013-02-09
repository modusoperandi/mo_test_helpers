$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mo_test_helpers/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mo_test_helpers"
  s.version     = MoTestHelpers::VERSION
  s.authors     = ["Max Schulze"]
  s.email       = ["max@mo-stud.io"]
  s.homepage    = "http://mo-stud.io"
  s.summary     = "General tools for making our setup and life with tests easier."
  s.description = "Pre-defined configurations and tools for running common tasks using the MO style guidelines."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "cucumber",              ">= 1.2.1"
  s.add_dependency "rspec",                 ">= 2.8.0"
  s.add_dependency "database_cleaner",      ">= 0.9.1"
  s.add_dependency "factory_girl",          ">= 3.1.0"
  s.add_dependency "watir",                 ">= 4.0.2"
  s.add_dependency "capybara",              ">= 1.1.2"
  s.add_dependency "selenium-webdriver",    ">= 2.25.0"
  s.add_dependency "headless",              ">= 0.3.1"
  s.add_dependency "simplecov",             ">= 0.7.1"
  s.add_dependency "simplecov-rcov",        ">= 0.2.3"
end