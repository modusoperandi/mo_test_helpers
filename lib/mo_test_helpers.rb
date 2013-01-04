module MoTestHelpers
  
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "mo_test_helpers/tasks/test_helpers.rake"
    end
  end
  
end
