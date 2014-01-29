module DataMapper
  module Dynamodb
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
  end
end
