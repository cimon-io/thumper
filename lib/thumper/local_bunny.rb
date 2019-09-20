# frozen_string_literal: true

module Thumper
  class LocalBunny
    def initialize(url, base_name)
      @amqp = Bunny.new(url).tap(&:start)
      @channel = @amqp.create_channel
      @fanout = @channel.fanout("ex.#{base_name}", durable: true)
      @queue = @channel.queue("qe.#{base_name}", durable: true)
    end

    def publish(data, routing_key:)
      @fanout.publish(data.to_json, routing_key: routing_key, durable: true)
    end

    def subscribe(&block)
      @queue.subscribe(block: true, manual_ack: true) do |delivery_info, _metadata, payload|
        block.call(JSON.parse(payload).symbolize_keys)
        @channel.acknowledge(delivery_info.delivery_tag, false)
      end
    end
  end
end

# rubocop:disable Style/GlobalVars
$amqp_name = ENV['AMQP_NAME'] if ENV['AMQP_NAME']

if ENV['AMQP_URL']
  $amqp_url = ENV['AMQP_URL']
else
  host = ENV.fetch('AMQP_HOST', 'localhost')
  port = ENV.fetch('AMQP_PORT', '5672')
  user = ENV.fetch('AMQP_USER', 'guest')
  pswd = ENV.fetch('AMQP_PSWD', 'guest')
  $amqp_url = "amqp://#{user}:#{pswd}@#{host}:#{port}"
end

$bunny = Thumper::LocalBunny.new($amqp_url, $amqp_name)
# rubocop:enable Style/GlobalVars
