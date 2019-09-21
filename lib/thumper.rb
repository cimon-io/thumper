require 'thumper/version'
require 'thumper/railtie' if defined?(Rails)
require 'thumper/local_bunny'

module Thumper
  class Error < StandardError; end

  class << self
    def client
      Thumper::LocalBunny.instance
    end
  end
end
