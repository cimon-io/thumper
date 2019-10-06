# frozen_string_literal: true

require 'bunny'
module Thumper
  class LocalBunny
    include Singleton

    def publish(data, **kwargs)
      fanout.publish(data.to_json, durable: true, **kwargs)
    end

    def subscribe(&block)
      queue.subscribe(block: true, manual_ack: true) do |delivery_info, metadata, payload|
        block.call(topic: delivery_info.routing_key, data: JSON.parse(payload).symbolize_keys, timestamp: metadata.timestamp)
        channel.acknowledge(delivery_info.delivery_tag, false)
      end
    end

    def url
      @url ||= if ENV['AMQP_URL']
                 ENV['AMQP_URL']
               else
                 host = ENV.fetch('AMQP_HOST', 'localhost')
                 port = ENV.fetch('AMQP_PORT', '5672')
                 user = ENV.fetch('AMQP_USER', 'guest')
                 pswd = ENV.fetch('AMQP_PSWD', 'guest')
                 "amqp://#{user}:#{pswd}@#{host}:#{port}"
               end
    end

    def base_name
      @base_name ||= ENV['AMQP_NAME'] if ENV['AMQP_NAME']
    end

    def amqp
      @amqp ||= Bunny.new(url).tap(&:start)
    end

    def channel
      @channel ||= amqp.create_channel
    end

    def fanout
      @fanout ||= channel.fanout("ex.#{base_name}", durable: true, no_declare: true)
    end

    def queue
      @queue ||= channel.queue("qe.#{base_name}", durable: true, no_declare: true)
    end
  end
end
