module DataMapper
  module Dynamodb
    class Primitive
      class Object < Base
        def to_dynamodb
          marshal(value)
        end

        def from_dynamodb
          unmarshal(value)
        end

        def type_in_dynamodb
          'b'
        end
      end
    end
  end
end
