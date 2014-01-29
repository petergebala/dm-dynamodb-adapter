require 'spec_helper'

class Dummy
  include DataMapper::Resource

  storage_names[:default] = 'table-name-db'

  property :id, Serial
  property :first_name, String, key: true
  property :last_name, String
  property :email, String
end

describe DataMapper::Dynamodb::Adapter do
  before(:all) do
    DataMapper.finalize
  end

  it 'create item' do
    expect { item = Dummy.create(id: 1, first_name: 'a', last_name: 'b', email: 'c') }.not_to raise_error
  end

  it 'update item' do
    expect { @item = Dummy.create(id: 1, first_name: 'a', last_name: 'b', email: 'c') }.not_to raise_error
    expect { @item.update(last_name: 'z') }.not_to raise_error
    @item.last_name.should eq 'z'
  end

  it 'read item' do
    expect { @item = Dummy.create(id: 1, first_name: 'a', last_name: 'b', email: 'c') }.not_to raise_error
    record = Dummy.get(1, 'a')
    record.id.should eq 1
    record.first_name.should eq 'a'
  end

  it 'delete item' do
    expect { @item = Dummy.create(id: 1, first_name: 'a', last_name: 'b', email: 'c') }.not_to raise_error
    expect { @item.destroy }.not_to raise_error
  end
end

