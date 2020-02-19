# frozen_string_literal: true

namespace :messagebroker do
  desc 'Starts watching on messages from RabbbitMQ side'
  task watch: :environment do
    Thumper.client.subscribe

    trap('TERM', 'EXIT')

    at_exit do
      SuckerPunch::Queue.shutdown_all
      Thumper.client.unsubscribe
    end

    loop { sleep 60 }
  end
end
