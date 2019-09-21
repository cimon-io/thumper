namespace :messagebroker do
  desc 'Starts watching on messages from RabbbitMQ side'
  task watch: :environment do
    Thumper.client.subscribe { |*args| Thumper::BunnyJob.perform_later(*args) }
  end
end
