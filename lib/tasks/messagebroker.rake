namespace :messagebroker do
  desc 'Starts watching on messages from RabbbitMQ side'
  task watch: :environment do
    subscription_class = Thumper.subscription_job_class

    consumer = Thumper.client.subscribe { |args| subscription_class.perform_later(args) } if subscription_class

    trap('SIGTERM') { exit }

    at_exit do
      next if consumer.nil?

      consumer.cancel
      Thumper.client.channel.close
    end

    loop { sleep 60 }
  end
end
