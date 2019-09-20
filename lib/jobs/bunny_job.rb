module Thumper
  class BunnyJob < ApplicationJob
    queue_as :bunny

    def perform(topic:, data:, timestamp:)
      Rails.logger.info(topic: topic, data: data, timestamp: timestamp)
    end
  end
end
