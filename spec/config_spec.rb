require 'spec_helper'

describe DataMapper::Adapters::DynamodbAdapter::Config do
  before do
    DataMapper::Adapters::DynamodbAdapter::Config.setup do |config|
      config.aws_access_key = 'xxx'
      config.aws_secret_key = 'yyy'
      config.aws_region     = 'rrr'
    end
  end

  it 'should check exisitng of credentials' do
    DataMapper::Adapters::DynamodbAdapter::Config.aws_access_key.should eq 'xxx'
    DataMapper::Adapters::DynamodbAdapter::Config.aws_secret_key.should eq 'yyy'
    DataMapper::Adapters::DynamodbAdapter::Config.aws_region.should eq 'rrr'
  end

  it 'should not accept wrong options' do
    expect { DataMapper::Adapters::DynamodbAdapter::Config.aws_wrong_option = 'value' }.to raise_error
  end

  it 'should raise error with missing credentials' do
    DataMapper::Adapters::DynamodbAdapter::Config.aws_region = nil
    expect { DataMapper::Adapters::DynamodbAdapter.new(:name, {}) }.to raise_error(MissingOption)
  end

  context '.other_option_to_hash' do
    it 'should in default return empty hash' do
      DataMapper::Adapters::DynamodbAdapter::Config.other_option_to_hash.should eq Hash.new
    end

    it 'should return set optional options' do
      DataMapper::Adapters::DynamodbAdapter::Config.ssl_ca_bundle = 'a'
      DataMapper::Adapters::DynamodbAdapter::Config.http_continue_timeout = 1

      hash = { ssl_ca_bundle: 'a', http_continue_timeout: 1 }
      DataMapper::Adapters::DynamodbAdapter::Config.other_option_to_hash.should eq hash
    end
  end
end
