# Dm::Dynamodb::Adapter

DynamodDb adapter for DataMapper

## Installation

Add this line to your application's Gemfile:

    gem 'dm-dynamodb-adapter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dm-dynamodb-adapter

## Usage

### Configuration

In initializer or configuration file please fill crendetials:

```ruby
  DataMapper::Adapters::DynamodbAdapter::Config.setup do |config|
    config.aws_access_key = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.aws_region     = ENV['AWS_REGION']
  end
```

### Tests:

Export your test db credentials:

```bash
  export AWS_ACCESS_KEY_ID='...'
  export AWS_SECRET_ACCESS_KEY='...'
  export AWS_REGION='...'
```

Run: `rspec spec` to check if tests are passing.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
