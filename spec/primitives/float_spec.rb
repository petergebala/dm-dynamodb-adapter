require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Float do
  let(:integer) { (Kernel.rand*100).to_i }
  let(:float) { integer/4.0 }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(float, 'Float') }

  context '#initializer' do
    it 'should wrap to Float wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Float
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq float.to_s
    end
  end

  context '#from_dynamodb' do
    it 'should load value as float' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should eq float
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 's'
    end
  end
end
