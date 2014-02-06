module DataMapper
  module Dynamodb
    class Primitive
      class Object < Base
        def to_dynamodb
          [ Marshal.dump(value) ].pack('m')
        end

        def from_dynamodb
          Marshal.load(value.unpack('m').first)
        end

        def type_in_dynamodb
          'b'
        end
      end
    end
  end
end
