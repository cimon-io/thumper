module Thumper
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/messagebroker.rake'
    end
  end
end
