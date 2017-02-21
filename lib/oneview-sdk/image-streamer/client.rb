# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../client'

module OneviewSDK
  module ImageStreamer
    # The client defines the connection to the Image Streamer server and handles communication with it.
    class Client < OneviewSDK::Client
      undef :user
      undef :user=
      undef :password
      undef :password=
      undef :refresh_login

      # Creates client object, establish connection, and set up logging and api version.
      # @param [Hash] options the options to configure the client
      # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
      #   Must implement debug(String), info(String), warn(String), error(String), & level=
      # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
      # @option options [Boolean] :print_wait_dots (false) When true, prints status dots while waiting on the tasks to complete.
      # @option options [String] :url URL of Image Streamer
      # @option options [String] :token (ENV['ONEVIEWSDK_TOKEN']) The token to use for authentication
      # @option options [Integer] :api_version (300) This is the API version to use by default for requests
      # @option options [Boolean] :ssl_enabled (true) Use ssl for requests? Respects ENV['I3S_SSL_ENABLED']
      # @option options [Integer] :timeout (nil) Override the default request timeout value
      def initialize(options = {})
        options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
        STDOUT.sync = true
        @logger = options[:logger] || Logger.new(STDOUT)
        [:debug, :info, :warn, :error, :level=].each { |m| raise InvalidClient, "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
        self.log_level = options[:log_level] || :info
        @print_wait_dots = options.fetch(:print_wait_dots, false)
        @url = options[:url] || ENV['I3S_URL']
        raise InvalidClient, 'Must set the url option' unless @url
        @max_api_version = appliance_i3s_api_version
        if options[:api_version] && options[:api_version].to_i > @max_api_version
          logger.warn "API version #{options[:api_version]} is greater than the Image Streamer API version (#{@max_api_version})"
        end
        @api_version = options[:api_version] || [OneviewSDK::ImageStreamer::DEFAULT_API_VERSION, @max_api_version].min
        # Set the default Image Streamer module API version
        OneviewSDK::ImageStreamer.api_version = @api_version unless
          OneviewSDK::ImageStreamer.api_version_updated? || !OneviewSDK::ImageStreamer::SUPPORTED_API_VERSIONS.include?(@api_version)
        @ssl_enabled = true
        if ENV.key?('I3S_SSL_ENABLED')
          if %w(true false 1 0).include?(ENV['I3S_SSL_ENABLED'])
            @ssl_enabled = !%w(false 0).include?(ENV['I3S_SSL_ENABLED'])
          else
            @logger.warn "Unrecognized ssl_enabled value '#{ENV['I3S_SSL_ENABLED']}'. Valid options are 'true' & 'false'"
          end
        end
        @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
        @timeout = options[:timeout] unless options[:timeout].nil?
        @cert_store = OneviewSDK::SSLHelper.load_trusted_certs if @ssl_enabled
        raise InvalidClient, 'Must set token option' unless options[:token] || ENV['ONEVIEWSDK_TOKEN']
        @token = options[:token] || ENV['ONEVIEWSDK_TOKEN']
      end

      # Get array of all resources of a specified type
      # @param [String] type Resource type
      # @param [Integer] api_ver API module version to fetch resources from
      # @return [Array<Resource>] Results
      # @example Get all Deployment Plans
      #   deployment_plans = @client.get_all('DeploymentPlans')
      # @raise [TypeError] if the type is invalid
      def get_all(type, api_ver = @api_version)
        klass = OneviewSDK::ImageStreamer.resource_named(type, api_ver)
        raise TypeError, "Invalid resource type '#{type}'. OneviewSDK::ImageStreamer::API#{api_ver} does not contain a class like it." unless klass
        klass.get_all(self)
      end

      private

      # Get current api version from the Image Streamer
      def appliance_i3s_api_version
        options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => :none }
        response = rest_api(:get, '/rest/version', options)
        version = response_handler(response)['currentVersion']
        raise ConnectionError, "Couldn't get API version" unless version
        version = version.to_i if version.class != Fixnum
        version
      rescue ConnectionError
        @logger.warn "Failed to get Image Streamer max api version. Using default (#{OneviewSDK::ImageStreamer::DEFAULT_API_VERSION})"
        OneviewSDK::ImageStreamer::DEFAULT_API_VERSION
      end
    end
  end
end
