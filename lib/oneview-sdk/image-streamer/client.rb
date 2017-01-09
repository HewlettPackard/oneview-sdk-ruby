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

require 'logger'
require_relative '../config_loader'
require_relative '../rest'
require_relative '../ssl_helper'

module OneviewSDK
  module ImageStreamer
    # The client defines the connection to the Image Streamer server and handles communication with it.
    class Client
      attr_reader :url, :token, :max_api_version
      attr_accessor :ssl_enabled, :api_version, :logger, :log_level, :cert_store, :print_wait_dots, :timeout

      include Rest

      # Creates client object, establish connection, and set up logging and api version.
      # @param [Hash] options the options to configure the client
      # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
      #   Must implement debug(String), info(String), warn(String), error(String), & level=
      # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
      # @option options [Boolean] :print_wait_dots (false) When true, prints status dots while waiting on the tasks to complete.
      # @option options [String] :url URL of Image Streamer
      # @option options [String] :token (ENV['ONEVIEWSDK_I3S_TOKEN']) The token to use for authentication with Image Streamer
      # @option options [Integer] :api_version (300) This is the API version to use by default for requests
      # @option options [Boolean] :ssl_enabled (true) Use ssl for requests? Respects ENV['ONEVIEWSDK_I3S_SSL_ENABLED']
      # @option options [Integer] :timeout (nil) Override the default request timeout value
      def initialize(options = {})
        options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
        STDOUT.sync = true
        @logger = options[:logger] || Logger.new(STDOUT)
        [:debug, :info, :warn, :error, :level=].each { |m| raise InvalidClient, "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
        @log_level = options[:log_level] || :info
        @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
        @print_wait_dots = options.fetch(:print_wait_dots, false)
        @url = options[:url] || ENV['ONEVIEWSDK_I3S_URL']
        raise InvalidClient, 'Must set the url option' unless @url
        @max_api_version = appliance_api_version
        if options[:api_version] && options[:api_version].to_i > @max_api_version
          logger.warn "API version #{options[:api_version]} is greater than the Image Streamer API version (#{@max_api_version})"
        end
        @api_version = options[:api_version] || [OneviewSDK::ImageStreamer::DEFAULT_API_VERSION, @max_api_version].min
        # Set the default Image Streamer module API version
        OneviewSDK::ImageStreamer.api_version = @api_version unless
          OneviewSDK::ImageStreamer.api_version_updated? || !OneviewSDK::ImageStreamer::SUPPORTED_API_VERSIONS.include?(@api_version)
        @ssl_enabled = true
        if ENV.key?('ONEVIEWSDK_I3S_SSL_ENABLED')
          if %w(true false 1 0).include?(ENV['ONEVIEWSDK_I3S_SSL_ENABLED'])
            @ssl_enabled = !%w(false 0).include?(ENV['ONEVIEWSDK_I3S_SSL_ENABLED'])
          else
            @logger.warn "Unrecognized ssl_enabled value '#{ENV['ONEVIEWSDK_I3S_SSL_ENABLED']}'. Valid options are 'true' & 'false'"
          end
        end
        @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
        @timeout = options[:timeout] unless options[:timeout].nil?
        @cert_store = OneviewSDK::SSLHelper.load_trusted_certs if @ssl_enabled
        raise InvalidClient, 'Must set token option' unless options[:token] || ENV['ONEVIEWSDK_I3S_TOKEN']
        @token = options[:token] || ENV['ONEVIEWSDK_I3S_TOKEN']
      end

      # Tells OneView to create the resource using the current attribute data
      # @param [Resource] resource the object to create
      def create(resource)
        resource.client = self
        resource.create
      end

      # Sets the attribute data, and then saves to OneView
      # @param [Resource] resource the object to update
      def update(resource, attributes = {})
        resource.client = self
        resource.update(attributes)
      end

      # Updates this object using the data that exists on OneView
      # @param [Resource] resource the object to refresh
      def refresh(resource)
        resource.client = self
        resource.refresh
      end

      # Deletes this object from OneView
      # @param [Resource] resource the object to delete
      def delete(resource)
        resource.client = self
        resource.delete
      end

      # Get array of all resources of a specified type
      # @param [String] type Resource type
      # @param [Integer] api_ver API module version to fetch resources from
      # @return [Array<Resource>] Results
      # @example Get all Deployment Plans
      #   deployment_plans = @client.get_all('DeploymentPlans')
      # @raise [TypeError] if the type is invalid
      def get_all(type, api_ver = @api_version)
        klass = OneviewSDK.resource_named(type, api_ver)
        raise TypeError, "Invalid resource type '#{type}'. OneviewSDK::ImageStreamer::API#{api_ver} does not contain a class like it." unless klass
        klass.get_all(self)
      end

      # Wait for a task to complete
      # @param [String] task_uri
      # @raise [OneviewSDK::TaskError] if the task resulted in an error or early termination.
      # @return [Hash] if the task completed successfully, return the task details
      def wait_for(task_uri)
        raise ArgumentError, 'Must specify a task_uri!' if task_uri.nil? || task_uri.empty?
        loop do
          task_uri.gsub!(%r{https:(.*)\/rest}, '/rest')
          task = rest_get(task_uri)
          body = JSON.parse(task.body)
          case body['taskState'].downcase
          when 'completed'
            return body
          when 'warning'
            @logger.warn "Task ended with warning status. Details: #{JSON.pretty_generate(body['taskErrors']) rescue body}"
            return body
          when 'error', 'killed', 'terminated'
            msg = "Task ended with bad state: '#{body['taskState']}'.\nResponse: "
            msg += body['taskErrors'] ? JSON.pretty_generate(body['taskErrors']) : JSON.pretty_generate(body)
            raise TaskError, msg
          else
            print '.' if @print_wait_dots
            sleep 10
          end
        end
      end

      private

      # Get current api version from the Image Streamer
      def appliance_api_version
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
