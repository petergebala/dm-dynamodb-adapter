module DataMapper
  module Dynamodb
    class Primitive
      class Date < Base
        def to_dynamodb
          value.to_time.to_i.to_s
        end

        def from_dynamodb
          ::Time.at(value.to_i).to_date
        end

        def type_in_dynamodb
          'n'
        end
      end
    end
  end
end
