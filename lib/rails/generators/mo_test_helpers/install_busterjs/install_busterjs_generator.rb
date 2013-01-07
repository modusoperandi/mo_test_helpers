# encoding: utf-8

module MoTestHelpers
  module Generators
    class InstallBusterjsGenerator < Rails::Generators::Base
      desc 'Installs BusterJS and initial config files'
      
      source_root File.expand_path("../templates", __FILE__)
      
      def create_folder_structure
        empty_directory File.join('app', 'assets', 'tests')
        empty_directory File.join('app', 'assets', 'tests', 'Helpers')
        empty_directory File.join('app', 'assets', 'tests', 'Specs')
        empty_directory File.join('app', 'assets', 'tests', 'Specs', 'App')
        empty_directory File.join('app', 'assets', 'tests', 'Specs', 'App', 'Collections')
        empty_directory File.join('app', 'assets', 'tests', 'Specs', 'App', 'Models')
        empty_directory File.join('app', 'assets', 'tests', 'Specs', 'App', 'Routers')
        empty_directory File.join('app', 'assets', 'tests', 'Specs', 'App', 'Utils')
      end
      
      def create_config_file
        copy_file "buster.js", "app/assets/tests/buster.js"
        copy_file "package.json", "app/assets/app/package.json"
        copy_file "pre.js.coffee", "app/assets/tests/Helpers/pre.js.coffee"
        copy_file "post.js.coffee", "app/assets/tests/Helpers/post.js.coffee"
      end
      
      def diplay_note
        puts "WARNING: Please now go to app/assets/tests and run 'npm install' to install all dependencies!"
      end
    end
  end
end