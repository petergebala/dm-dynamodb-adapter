require 'pry'

module DataMapper
  module Dynamodb
    module Aggregates
      ##
      # Refered from: dm-aggregates/lib/dm-aggregates/repository.rb#aggreagte
      def aggregate(query)
        table_name = query.model.storage_name

        if query.fields.all?{ |a| a.target == :all }
          operation_type = query.fields.first.operator
        end

        case operation_type
        when :count
          result = @adapter.scan(table_name: table_name,
                                 select: 'COUNT',
                                 return_consumed_capacity: 'TOTAL')
          result = [result[:count]]
        else
          raise OperationNotImplemented, "Please implemenet operation #{operation_type}."
        end

        result
      end
    end
  end
end
