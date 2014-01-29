require 'spec_helper'

describe DataMapper::Dynamodb::Config do
  before do
    DataMapper::Dynamodb::Config.setup do |config|
      config.aws_access_key = 'xxx'
      config.aws_secret_key = 'yyy'
      config.aws_region     = 'rrr'
    end
  end

  it 'should check exisitng of credentials' do
    DataMapper::Dynamodb::Config.aws_access_key.should eq 'xxx'
    DataMapper::Dynamodb::Config.aws_secret_key.should eq 'yyy'
    DataMapper::Dynamodb::Config.aws_region.should eq 'rrr'
  end

  it 'should not accept wrong options' do
    expect { DataMapper::Dynamodb::Config.aws_wrong_option = 'value' }.to raise_error
  end

  it 'should raise error with missing credentials' do
    DataMapper::Dynamodb::Config.aws_region = nil
    expect { DataMapper::Dynamodb::Adapter.new(:name, {}) }.to raise_error(MissingOption)
  end

  context '.other_option_to_hash' do
    it 'should in default return empty hash' do
      DataMapper::Dynamodb::Config.other_option_to_hash.should eq ({ api_version: '2012-08-10' })
    end

    it 'should return set optional options' do
      DataMapper::Dynamodb::Config.ssl_ca_bundle = 'a'
      DataMapper::Dynamodb::Config.http_continue_timeout = 1

      hash = { api_version: '2012-08-10', ssl_ca_bundle: 'a', http_continue_timeout: 1 }
      DataMapper::Dynamodb::Config.other_option_to_hash.should eq hash
    end
  end
end
