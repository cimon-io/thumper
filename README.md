# Thumper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/thumper`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thumper', github: 'cimon-io/thumper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thumper

## Usage

1. Add following line to a projects' `Procfile`:

```
broker: ./bin/rake messagebroker:watch
```

2. Configure sucker_punch (optional):

```
# config/initializers/sucker_punch.rb
require 'sucker_punch'

SuckerPunch.exception_handler = ->(exception, _klass, _args) { Raven.capture_exception(exception) }
SuckerPunch.shutdown_timeout = 8
```

3. Create a class to handle subscription events and configure it inside initializer file:

```
# lib/bunny_service.rb
class BunnyService
  def call(topic:, data:, timestamp:, uuid:)
    Rails.logger.info(topic: topic, data: data, timestamp: timestamp, uuid: uuid)
  end
end
```

```
# config/initializers/thumper_initializer.rb
Thumper.subscription_class = BunnyService
```

4. Following ENV variables should be configured as well:

```
AMQP_NAME
AMQP_URL
AMQP_HOST
AMQP_PORT
AMQP_USER
AMQP_PSWD
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/thumper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Thumper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/thumper/blob/master/CODE_OF_CONDUCT.md).
