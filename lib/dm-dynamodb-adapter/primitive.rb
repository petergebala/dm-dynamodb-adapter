module DataMapper
  module Dynamodb
    class Primitive
      attr_reader :value, :primitive

      def initialize(value, primitive)
        @value, @primitive = value, primitive
      end

      def to_dynamodb
        dynamodb_primitive.send(:to_dynamodb)
      end

      def from_dynamodb
        dynamodb_primitive.send(:from_dynamodb)
      end

      def type_in_dynamodb
        dynamodb_primitive.send(:type_in_dynamodb)
      end

      private
      def dynamodb_primitive
        Object.module_eval("DataMapper::Dynamodb::Primitive::#{primitive}").new(value, primitive)
      end
    end
  end
end
