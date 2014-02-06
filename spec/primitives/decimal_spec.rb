require 'spec_helper'

describe DataMapper::Dynamodb::Primitive::Decimal do
  let(:integer) { (Kernel.rand*100).to_i }
  let(:decimal) { integer/4.0 }
  let(:primitive) { DataMapper::Dynamodb::Primitive.new(decimal, 'Decimal') }

  context '#initializer' do
    it 'should wrap to Decimal wrapper' do
      primitive.send(:dynamodb_primitive).should be_an_instance_of DataMapper::Dynamodb::Primitive::Decimal
    end
  end

  context '#to_dynamodb' do
    it 'should save value as string' do
      primitive.to_dynamodb.should eq decimal.to_s
    end
  end

  context '#from_dynamodb' do
    it 'should load value as bignum' do
      primitive.value = primitive.to_dynamodb
      primitive.from_dynamodb.should eq BigDecimal.new(decimal.to_s)
    end
  end

  context '#type_in_dynamodb' do
    it 'should return string type for DynamoDB' do
      primitive.type_in_dynamodb.should eq 's'
    end
  end
end
