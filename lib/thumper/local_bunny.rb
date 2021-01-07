# frozen_string_literal: true

require 'bunny'
require 'securerandom'

module Thumper
  class LocalBunny
    include Singleton

    attr_reader :consumer

    def publish(data, routing_key:, **kwargs) # rubocop:disable Metrics/MethodLength
      fanout.publish(
        {
          timestamp: Time.current.strftime('%FT%T.%3N%z'),
          topic: routing_key,
          data: data,
          from: base_name,
          uuid: SecureRandom.uuid
        }.to_json,
        durable: true,
        routing_key: routing_key,
        **kwargs
      )
    end

    def subscribe(**options)
      raise MissingSubscriptionClassError if Thumper.subscription_class.nil?

      @consumer = queue.subscribe(block: false, manual_ack: true, **options) do |delivery_info, _metadata, payload|
        message = JSON.parse(payload)
        BunnyJob.perform_async(channel, delivery_info.delivery_tag, topic: message['topic'], data: message['data'].symbolize_keys, timestamp: message['timestamp'], uuid: message['uuid'])
      end
    end

    def unsubscribe
      consumer.cancel
      channel.close
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
