require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Date do
  let(:date) { Date.new(2000) }
  let(:date_integer) { 946681200 }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(date, 'Date') }

  context '#initializer' do
    it 'should wrap to Date wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Date
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq date_integer.to_s
    end
  end

  context '#from_dynamodb' do
    it 'should load value as boolean' do
      primitive.value = date_integer
      primitive.from_dynamodb.should eq date
    end
  end

  context '#type_in_dynamodb' do
    it 'should return number type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 'n'
    end
  end
end
