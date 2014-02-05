module DataMapper
  module Dynamodb
    class Primitive
      class Time < Base
        def to_dynamodb
          value.to_f.to_s
        end

        def from_dynamodb
          ::Time.at(value.to_f)
        end

        def type_in_dynamodb
          's'
        end
      end
    end
  end
end
