module DataMapper
  module Dynamodb
    class Primitive
      class Float < Base
        def to_dynamodb
          value.to_s
        end

        def from_dynamodb
          value.to_f
        end

        def type_in_dynamodb
          's'
        end
      end
    end
  end
end
