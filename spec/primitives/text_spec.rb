require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Text do
  let(:text) { 'some string' }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(text, 'Text') }

  context '#initializer' do
    it 'should wrap to Text wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Text
    end
  end

  context '#to_dynamodb' do
    it 'should save value as text' do
      primitive.to_dynamodb.should eq text
    end
  end

  context '#from_dynamodb' do
    it 'should load value as text' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should eq text
    end
  end

  context '#type_in_dynamodb' do
    it 'should return text type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 's'
    end
  end
end
