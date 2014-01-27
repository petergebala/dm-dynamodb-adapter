require 'dm-core'
require 'dm-dynamodb-adapter/adapter'
require 'dotenv'
require 'pry'

Dotenv.load

DataMapper::Adapters::DynamodbAdapter::Config.setup do |config|
  config.aws_access_key = ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.aws_region     = ENV['AWS_REGION']
  config.api_version    = ENV['API_VERSION']
end

DataMapper.setup(:default, { adapter: :dynamodb })
