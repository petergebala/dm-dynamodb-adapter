module DataMapper
  module Dynamodb
    class Primitive
      class Time < Base
        def to_dynamodb
          value.to_i
        end

        def from_dynamodb
          ::Time.at(value.to_i)
        end

        def type_in_dynamodb
          'n'
        end
      end
    end
  end
end
