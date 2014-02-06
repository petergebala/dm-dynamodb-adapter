module DataMapper
  module Dynamodb
    class Primitive
      class Serial < Base
        def to_dynamodb
          value.to_s
        end

        def from_dynamodb
          value.to_i
        end

        def type_in_dynamodb
          'n'
        end
      end
    end
  end
end
