module DataMapper
  module Dynamodb
    class Primitive
      class Base < Primitive
        def to_dynamodb
          raise PrimitiveNotImplemented, "Need to be implemented #{self.class.name}#to_dynamodb"
        end

        def from_dynamodb
          raise PrimitiveNotImplemented, "Need to be implemented #{self.class.name}#from_dynamodb"
        end

        def type_in_dynamodb
          raise PrimitiveNotImplemented, "Need to be implemented #{self.class.name}#type_in_dynamodb"
        end
      end
    end
  end
end
