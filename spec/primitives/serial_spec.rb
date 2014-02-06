require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Serial do
  let(:integer) { (Kernel.rand*100).to_i }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(integer, 'Serial') }

  context '#initializer' do
    it 'should wrap to Integer wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Serial
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq integer.to_s
    end
  end

  context '#from_dynamodb' do
    it 'should load value as integer' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should eq integer
    end
  end

  context '#type_in_dynamodb' do
    it 'should return number type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 'n'
    end
  end
end
