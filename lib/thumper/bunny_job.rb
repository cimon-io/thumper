# frozen_string_literal: true

module Thumper
  class BunnyJob
    include SuckerPunch::Job
    workers Thumper.max_workers

    def perform(channel, delivery_tag, topic:, data:, timestamp: nil, uuid: nil) # rubocop:disable Metrics/ParameterLists
      options = { topic: topic, data: data, timestamp: timestamp, uuid: uuid }
      Rails.logger.info(options)

      ActiveRecord::Base.connection_pool.with_connection do
        channel.acknowledge(delivery_tag, false) if Thumper.subscription_class.call(**options)
      end
    end
  end
end
