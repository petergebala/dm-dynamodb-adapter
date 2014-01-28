require "dm-dynamodb-adapter/version"
require 'dm-core'
require 'aws-sdk'

module DataMapper
  module Adapters
    class DynamodbAdapter < AbstractAdapter
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
            item[key.to_s] = value_to_dynamodb(value)
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
                                                attribute_value_list: [value_to_dynamodb(condition.value)],
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
        binding.pry

        valid_records = records[:member].map{ |hash| dynamodb_to_value(hash) }

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
            item[key.name.to_s][:value]   = value_to_dynamodb(value)
            item[key.name.to_s][:action]  = 'PUT'
          end

          resource.model.primary_keys.each do |primary_key|
            key[primary_key.name.to_s] = value_to_dynamodb(resource.attributes[primary_key.name])
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
            key[primary_key.name.to_s] = value_to_dynamodb(resource.attributes[primary_key.name])
          end

          @adapter.delete_item(table_name: table_name,
                               key: key,
                               return_values: 'NONE',
                               return_consumed_capacity: 'TOTAL',
                               return_item_collection_metrics: 'NONE')
        end
      end

      private
      def tables
        @adapter.list_tables
      end

      def describe_table(resource)
        @adapter.describe_table(table_name: resource.model.storage_name)
      end

      def check_presence_of_aws_credentials
        Config::REQUIRED_OPTIONS.each do |option|
          raise MissingOption, "Can't find #{option}" unless Config.send(option)
        end
      end

      def value_to_dynamodb(value)
        case value.class.name
        when 'Numeric', 'Fixnum', 'Float', 'Bignum'
          { 'n' => value.to_s }
        when 'DateTime', 'Time'
          { 'n' => value.to_time.to_f.to_s }
        when 'IO'
          { 'b' => value }
        when 'Array'
          if value.all? { |v| v.is_a?(::Numeric) }
            { 'ns' => value }
          elsif value.all? { |v| v.is_a?(::IO) }
            { 'bs' => value }
          else
            { 'ss' => value }
          end
        else
          { 's' => value }
        end
      end

      # GETS: { id: { n: "1" } }
      # RETURNS: { id: 1 }
      def dynamodb_to_value(hash)
        result = {}
        hash.each_pair do |key, value_hash|
          attribute_type = value_hash.flatten.first
          attribute_value = value_hash.flatten.last

          correct_value = case attribute_type.to_sym
                          when :s
                            attribute_value.to_s
                          when :n
                            attribute_value.to_f
                          when :b
                            ::IO.new(attribute_value)
                          when :ss
                            attribute_value.map(&:to_s)
                          when :ns
                            attribute_value.map(&:to_f)
                          when :bs
                            attribute_value.map{ |n| ::IO.new(n) }
                          end
          result[key] = correct_value
        end
        result
      end

      module Config
        REQUIRED_OPTIONS = [:aws_access_key, :aws_secret_key, :aws_region]

        @@aws_access_key = nil
        @@aws_secret_key = nil
        @@aws_region     = nil

        OPTIONAL_OPTIONS = [ :api_version,
                             :convert_params,
                             :credentials,
                             :endpoint,
                             :http_continue_timeout,
                             :http_idle_timeout,
                             :http_open_timeout,
                             :http_proxy,
                             :http_read_timeout,
                             :http_wire_trace,
                             :log_level,
                             :log_formatter,
                             :logger,
                             :raise_response_errors,
                             :raw_json,
                             :region,
                             :retry_limit,
                             :secret_access_key,
                             :session_token,
                             :sigv4_name,
                             :sigv4_region,
                             :ssl_ca_bundle,
                             :ssl_ca_directory,
                             :ssl_verify_peer,
                             :validate_params ]

        @@api_version           = nil # Default: '2012-08-10'
        @@convert_params        = nil # Default: true
        @@credentials           = nil
        @@endpoint              = nil
        @@http_continue_timeout = nil # Default: 1
        @@http_idle_timeout     = nil # Default: 5
        @@http_open_timeout     = nil # Default: 15
        @@http_proxy            = nil
        @@http_read_timeout     = nil # Default: 60
        @@http_wire_trace       = nil # Default: false
        @@log_level             = nil # Default: @@info
        @@log_formatter         = nil # Defaults to Seahorse::Client::Logging::Formatter.default
        @@logger                = nil # Default: nil
        @@raise_response_errors = nil # Default: true
        @@raw_json              = nil # Default: false
        @@region                = nil # Default: ENV['AWS_REGION']
        @@retry_limit           = nil # Default: 10
        @@secret_access_key     = nil # Defaults to ENV['AWS_SECRET_ACCESS_KEY']
        @@session_token         = nil # Defaults to ENV['AWS_SESSION_TOKEN']
        @@sigv4_name            = nil
        @@sigv4_region          = nil
        @@ssl_ca_bundle         = nil
        @@ssl_ca_directory      = nil
        @@ssl_verify_peer       = nil # Default: true
        @@validate_params       = nil # Default: true

        (REQUIRED_OPTIONS + OPTIONAL_OPTIONS).each do |mth|
          definition = %Q{ unless defined? @@#{mth}
                            @@#{mth} = nil
                          end

                          def self.#{mth}
                            @@#{mth}
                          end


                          def self.#{mth}=(obj)
                            @@#{mth} = obj
                          end }
          class_eval(definition)
        end

        def self.other_option_to_hash
          hash = {}
          OPTIONAL_OPTIONS.each do |option|
            hash[option] = self.send(option) unless self.send(option).nil?
          end
          hash
        end

        def self.setup
          yield self
        end
      end # Config

      module PropertyExt
        def primary_keys
          properties.select(&:key?)
        end

        def count
          table_name = storage_name
          self.repository.adapter.dbadapter.scan(table_name: table_name,
                                                 select: 'COUNT',
                                                 scan_filter: {},
                                                 return_consumed_capacity: 'TOTAL')[:count]
        end
      end

      ::DataMapper::Model.append_extensions(PropertyExt)
    end # DynamodbAdapter

    const_added(:DynamodbAdapter)
  end # Adapter
end # DataMapper

class MissingOption < StandardError; end
