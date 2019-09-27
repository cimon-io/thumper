require 'thumper/version'
require 'thumper/railtie' if defined?(Rails)
require 'thumper/local_bunny'

module Thumper
  class Error < StandardError; end

  class << self
    attr_accessor :subscription_job_class

    def client
      Thumper::LocalBunny.instance
    end
  end
end
