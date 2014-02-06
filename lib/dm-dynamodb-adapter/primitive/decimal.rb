module DataMapper
  module Dynamodb
    class Primitive
      class Decimal < Base
        def to_dynamodb
          value.to_s
        end

        def from_dynamodb
          BigDecimal.new(value)
        end

        def type_in_dynamodb
          's'
        end
      end
    end
  end
end
