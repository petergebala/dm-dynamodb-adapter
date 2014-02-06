require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::String do
  let(:string) { 'some string' }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(string, 'String') }

  context '#initializer' do
    it 'should wrap to String wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::String
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq string
    end
  end

  context '#from_dynamodb' do
    it 'should load value as String' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should eq string
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 's'
    end
  end
end
