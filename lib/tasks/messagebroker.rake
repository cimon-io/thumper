namespace :messagebroker do
  # rubocop:disable Style/GlobalVars
  desc "Starts watching on messages from RabbbitMQ side"
  task watch: :environment do
    $bunny.subscribe { |*args| Thumper::BunnyJob.perform_later(*args) }
  end
  # rubocop:enable Style/GlobalVars
end
