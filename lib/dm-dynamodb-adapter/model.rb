module DataMapper
  module Dynamodb
    module Model
      def tables
        repository.adapter.dbadapter.list_tables
      end

      def describe_table(resource)
        repository.adapter.dbadapter.describe_table(table_name: resource.model.storage_name)
      end

      def primary_keys
        properties.select(&:key?)
      end

      def count
        table_name = storage_name
        self.repository.adapter.dbadapter.scan(table_name: table_name,
                                                select: 'COUNT',
                                                scan_filter: {},
                                                return_consumed_capacity: 'TOTAL')[:count]
      end
    end
  end
end

::DataMapper::Model.append_extensions(DataMapper::Dynamodb::Model)
