require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Object do
  let(:object) { Object.new }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(object, 'Object') }

  context '#initializer' do
    it 'should wrap to Object wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Object
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq "BAhvOgtPYmplY3QA\n"
    end
  end

  context '#from_dynamodb' do
    it 'should load value as Object' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should be_an_instance_of Object
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 'b'
    end
  end
end
