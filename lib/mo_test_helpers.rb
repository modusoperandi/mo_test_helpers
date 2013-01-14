module MoTestHelpers
  
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "mo_test_helpers/tasks/test_helpers.rake"
    end
  end
  
  mattr_accessor :cucumber_engine
  self.cucumber_engine = :watir
  
end
