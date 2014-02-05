module DataMapper
  module Dynamodb
    class Primitive
      class Date < Base
        def to_dynamodb
          value.to_datetime.to_f.to_s
        end

        def from_dynamodb
          ::Time.at(value.to_f).to_date
        end

        def type_in_dynamodb
          's'
        end
      end
    end
  end
end
