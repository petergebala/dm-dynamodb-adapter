require "dm-dynamodb-adapter/version"
require 'dm-core'

module DataMapper
  module Addapters
    module DynamodbAdapter < AbstractAdapter
      # name: symbol
      # options: hash
      def initialize(name, options)
        super
        @connection = # Polaczenie do bazy danych
        @adapter = # baza danyh z conneciton

        @field_naming_convention = Proc.new {}
        @resource_naming_convention = Proc.new {}
      end

      # resources: array
      # return: number of resources created
      def create(resources)
      end

      # query: DataMapper::Query
      # return: array of hashes
      def read(query)
      end

      # changes: Hash of changes
      # resources: DataMapper::Collection
      # return: number of resources updated
      def update(changes, resources)
      end

      # resources: DataMapper::Collection
      # return: number of resources deleteed
      def delete(resources)

      end
    end
    const_added(:DynamodbAdapter)
  end
end
