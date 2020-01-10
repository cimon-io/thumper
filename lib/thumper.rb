module Thumper
  class Error < StandardError; end

  class MissingSubscriptionClassError < Error
    def message
      'Subscription class is not specified. Configure it with `Thumper.subscription_class = BunnyService`.'
    end
  end

  class << self
    attr_accessor :subscription_class

    def client
      Thumper::LocalBunny.instance
    end

    def max_workers
      @max_workers ||= 3
    end
  end
end

require 'thumper/version'
require 'thumper/railtie' if defined?(Rails)
require 'thumper/local_bunny'
require 'sucker_punch'
require 'thumper/bunny_job'
