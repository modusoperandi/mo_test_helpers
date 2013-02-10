M–O Test Helpers
================

This is a gem that just puts together some standard test tools that we need for both CI and manual testing.

Installation
------------

Add the gem to your Gemfile:

for external projects (not hosted on Stash):

    group :test do
      gem 'mo_test_helpers',      :git => 'git://github.com/modusoperandi/mo_test_helpers.git'
    end

for internal projects (hosted on Stash):

    group :test do
      gem 'mo_test_helpers',      :git => 'ssh://git@stash.mo-stud.io:7999/MO/test_helpers.git'
    end

Require the helpers at the top of your env.rb:

    require 'mo_test_helpers/cucumber'
  
and the rspec helpers on top of spec_helper

    require 'mo_test_helpers/rspec'

Cucumber
--------

For using cucumber there is a lot of different helpers. Let's start with the tags.

**Tags**

You can tag a cucumber scenario with the following:

* @iphone - Will run the scenario in an iPhone "firefox"
* @ipad - Will run the scenario in an iPad "firefox"
* @android_phone - Will run the scenario in an Android Phone "firefox"
* @android_tablet - Will run the scenario in an Android Tablet "firefox"
* @landscape - Only works in combination with any of those above.

**Environment Variables**

In order to control how the cucumber tests are being run, you can supply different environment variables.

* BROWSER - Which browser to run in