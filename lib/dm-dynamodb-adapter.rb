require 'dm-core'
require 'aws-sdk'

require 'dm-dynamodb-adapter/version'
require 'dm-dynamodb-adapter/config'
require 'dm-dynamodb-adapter/model'
require 'dm-dynamodb-adapter/primitive'
require 'dm-dynamodb-adapter/primitive/base'
require 'dm-dynamodb-adapter/primitive/boolean'
require 'dm-dynamodb-adapter/primitive/date'
require 'dm-dynamodb-adapter/primitive/date_time'
require 'dm-dynamodb-adapter/primitive/decimal'
require 'dm-dynamodb-adapter/primitive/float'
require 'dm-dynamodb-adapter/primitive/integer'
require 'dm-dynamodb-adapter/primitive/object'
require 'dm-dynamodb-adapter/primitive/serial'
require 'dm-dynamodb-adapter/primitive/string'
require 'dm-dynamodb-adapter/primitive/text'
require 'dm-dynamodb-adapter/primitive/time'

require 'dm-dynamodb-adapter/aggregates'
require 'dm-dynamodb-adapter/adapter'

class MissingOption < StandardError; end
class PrimitiveNotImplemented < NotImplementedError; end
class OperationNotImplemented < NotImplementedError; end
class ConditionNotImplemented < NotImplementedError; end
