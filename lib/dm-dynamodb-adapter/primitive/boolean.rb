module DataMapper
  module Dynamodb
    class Primitive
      class Boolean < Base
        def to_dynamodb
          value.to_s
        end

        def from_dynamodb
          value == 'true' ? true : false
        end

        def type_in_dynamodb
          's'
        end
      end
    end
  end
end
