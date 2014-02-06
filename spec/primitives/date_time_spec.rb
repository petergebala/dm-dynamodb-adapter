require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::DateTime do
  let(:date) { DateTime.new(2000, 1, 1, 1, 1, 1) }
  let(:date_integer) { 946688461 }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(date, 'DateTime') }

  context '#initializer' do
    it 'should wrap to DateTime wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::DateTime
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq date_integer
    end
  end

  context '#from_dynamodb' do
    it 'should load value as boolean' do
      primitive.value = date_integer
      primitive.from_dynamodb.should eq date
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 'n'
    end
  end
end
