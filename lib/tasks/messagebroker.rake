namespace :messagebroker do
  desc 'Starts watching on messages from RabbbitMQ side'
  task watch: :environment do
    subscription_class = Thumper.subscription_job_class

    Thumper.client.subscribe { |*args| subscription_class.perform_later(*args) } if subscription_class
  end
end
