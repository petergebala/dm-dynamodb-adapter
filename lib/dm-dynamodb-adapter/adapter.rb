module DataMapper
  module Dynamodb
    class Adapter < DataMapper::Adapters::AbstractAdapter
      include Aggregates

      attr_reader :adapter
      alias :dbadapter :adapter

      # Documentation
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/V20120810.html

      ##
      # name: symbol
      # options: hash
      def initialize(name, options)
        super
        check_presence_of_aws_credentials

        AWS.config(access_key_id: Config.aws_access_key,
                   secret_access_key: Config.aws_secret_key,
                   region: Config.aws_region)

        @connection = AWS::DynamoDB.new(dynamo_db: Config.other_option_to_hash)

        @adapter = @connection.client

        # @field_naming_convention = Proc.new {}
        # @resource_naming_convention = Proc.new {}
      end

      ##
      # resources: array
      # return: number of resources created
      def create(resources)
        resources.each do |resource|
          table_name = resource.model.storage_name
          item       = Hash.new

          resource.attributes.each_pair do |key, value|
            item[key.to_s] = value_to_dynamodb(resource.model, key, value) if value.present?
          end

          @adapter.put_item(table_name: table_name,
                            item: item,
                            return_values: 'ALL_OLD',
                            return_consumed_capacity: 'TOTAL',
                            return_item_collection_metrics: 'NONE')
        end
      end

      ##
      # query: DataMapper::Query
      # return: array of hashes
      def read(query)
        # query/scan
        # Query operates only on primary keys (like in SQL)
        # Scan reads entire table but it is more consuming
        condition_properties = query.condition_properties.clone
        table_name = query.model.storage_name
        attributes = query.model.properties.map(&:name).map(&:to_s)
        item       = Hash.new
        limit      = query.limit || query.model.count

        query.conditions.each do |condition|
          item[condition.subject.name.to_s] = {
                                                attribute_value_list: [value_to_dynamodb(query.model, condition.subject.name, condition.value)],
                                                comparison_operator: 'EQ'
                                              }
        end

        records = if condition_properties.any? && !condition_properties.select!(&:key?)
          @adapter.query(table_name: table_name,
                         select: 'SPECIFIC_ATTRIBUTES',
                         attributes_to_get: attributes,
                         limit: limit,
                         consistent_read: true,
                         key_conditions: item,
                         scan_index_forward: true,
                         return_consumed_capacity: 'TOTAL')
        else
          @adapter.scan(table_name: table_name,
                        select: 'SPECIFIC_ATTRIBUTES',
                        attributes_to_get: attributes,
                        limit: limit,
                        scan_filter: item,
                        return_consumed_capacity: 'TOTAL')
        end

        valid_records = records[:member].map{ |hash| dynamodb_to_value(query.model, hash) }

        query.filter_records(valid_records)
      end

      ##
      # changes: Hash of changes
      # resources: DataMapper::Collection
      # return: number of resources updated
      def update(changes, resources)
        resources.each do |resource|
          table_name = resource.model.storage_name
          item       = Hash.new
          key        = Hash.new

          changes.each_pair do |key, value|
            next if resource.model.primary_keys.include?(key)
            item[key.name.to_s] = {}
            item[key.name.to_s][:value]   = value_to_dynamodb(resource.model, key, value)
            item[key.name.to_s][:action]  = 'PUT'
          end

          resource.model.primary_keys.each do |primary_key|
            key[primary_key.name.to_s] = value_to_dynamodb(resource.model, key, resource.attributes[primary_key.name])
          end

          @adapter.update_item(table_name: table_name,
                               # Primary Key
                               key: key,
                               # For non-key attributes
                               attribute_updates: item,
                               return_values: 'UPDATED_NEW',
                               return_consumed_capacity: 'TOTAL',
                               return_item_collection_metrics: 'NONE')
        end
      end

      ##
      # resources: DataMapper::Collection
      # return: number of resources deleteed
      def delete(resources)
        resources.each do |resource|
          table_name = resource.model.storage_name
          key        = Hash.new

          resource.model.primary_keys.each do |primary_key|
            # key[primary_key.name.to_s] = value_to_dynamodb(resource.attributes[primary_key.name])
            key[primary_key.name.to_s] = value_to_dynamodb(resource.model, key, resource.attributes[primary_key.name])
          end

          @adapter.delete_item(table_name: table_name,
                               key: key,
                               return_values: 'NONE',
                               return_consumed_capacity: 'TOTAL',
                               return_item_collection_metrics: 'NONE')
        end
      end

      private
      def check_presence_of_aws_credentials
        Config::REQUIRED_OPTIONS.each do |option|
          raise MissingOption, "Can't find #{option}" unless Config.send(option)
        end
      end

      def value_to_dynamodb(model, key, value)
        model_property = model.properties[key]
        dynamodb_value_wrapper = Primitive.new(value, model_property.primitive)
        { dynamodb_value_wrapper.type_in_dynamodb => dynamodb_value_wrapper.to_dynamodb }
      end

      # GETS: { id: { n: "1" } }
      # RETURNS: { id: 1 }
      def dynamodb_to_value(model, hash)
        result = {}
        hash.each_pair do |name, value_hash|
          value_hash.each_pair do |key, value|
            model_property          = model.properties[name]
            dynamodb_value_wrapper  = Primitive.new(value, model_property.primitive)
            result[name]            = dynamodb_value_wrapper.from_dynamodb
          end
        end
        result
      end
    end # Adapter
  end # Dynamodb

  Adapters::DynamodbAdapter = DataMapper::Dynamodb::Adapter
  Adapters.const_added(:DynamodbAdapter)
end # DataMapper
