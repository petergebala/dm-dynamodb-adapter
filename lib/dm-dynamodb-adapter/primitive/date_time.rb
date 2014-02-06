module DataMapper
  module Dynamodb
    class Primitive
      class DateTime < Base
        def to_dynamodb
          value.to_time.to_i.to_s
        end

        def from_dynamodb
          ::Time.at(value.to_i).to_datetime
        end

        def type_in_dynamodb
          'n'
        end
      end
    end
  end
end
