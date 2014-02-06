require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Boolean do
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(false, 'Boolean') }

  context '#initializer' do
    it 'should wrap to Boolean wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Boolean
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq 'false'
    end
  end

  context '#from_dynamodb' do
    it 'should load value as boolean' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should be_false
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 's'
    end
  end
end
