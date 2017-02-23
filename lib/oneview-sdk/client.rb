# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'logger'
require_relative 'config_loader'
require_relative 'rest'
require_relative 'ssl_helper'

module OneviewSDK
  # The client defines the connection to the OneView server and handles communication with it.
  class Client
    attr_reader :max_api_version
    attr_accessor :url, :user, :token, :password, :domain, :ssl_enabled, :api_version, \
                  :logger, :log_level, :cert_store, :print_wait_dots, :timeout

    include Rest

    # Creates client object, establish connection, and set up logging and api version.
    # @param [Hash] options the options to configure the client
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :print_wait_dots (false) When true, prints status dots while waiting on the tasks to complete.
    # @option options [String] :url URL of OneView appliance
    # @option options [String] :user ('Administrator') The username to use for authentication with the OneView appliance
    # @option options [String] :password (ENV['ONEVIEWSDK_PASSWORD']) The password to use for authentication with OneView appliance
    # @option options [String] :domain ('LOCAL') The name of the domain directory used for authentication
    # @option options [String] :token (ENV['ONEVIEWSDK_TOKEN']) The token to use for authentication with OneView appliance
    #   Use the token or the username and password (not both). The token has precedence.
    # @option options [Integer] :api_version (200) This is the API version to use by default for requests
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests? Respects ENV['ONEVIEWSDK_SSL_ENABLED']
    # @option options [Integer] :timeout (nil) Override the default request timeout value
    def initialize(options = {})
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      STDOUT.sync = true
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| raise InvalidClient, "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      self.log_level = options[:log_level] || :info
      @print_wait_dots = options.fetch(:print_wait_dots, false)
      @url = options[:url] || ENV['ONEVIEWSDK_URL']
      raise InvalidClient, 'Must set the url option' unless @url
      @max_api_version = appliance_api_version
      if options[:api_version] && options[:api_version].to_i > @max_api_version
        logger.warn "API version #{options[:api_version]} is greater than the appliance API version (#{@max_api_version})"
      end
      @api_version = options[:api_version] || [OneviewSDK::DEFAULT_API_VERSION, @max_api_version].min
      # Set the default OneviewSDK module API version
      OneviewSDK.api_version = @api_version unless OneviewSDK.api_version_updated? || !OneviewSDK::SUPPORTED_API_VERSIONS.include?(@api_version)
      @ssl_enabled = true
      if ENV.key?('ONEVIEWSDK_SSL_ENABLED')
        if %w(true false 1 0).include?(ENV['ONEVIEWSDK_SSL_ENABLED'])
          @ssl_enabled = !%w(false 0).include?(ENV['ONEVIEWSDK_SSL_ENABLED'])
        else
          @logger.warn "Unrecognized ssl_enabled value '#{ENV['ONEVIEWSDK_SSL_ENABLED']}'. Valid options are 'true' & 'false'"
        end
      end
      @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
      @timeout = options[:timeout] unless options[:timeout].nil?
      @cert_store = OneviewSDK::SSLHelper.load_trusted_certs if @ssl_enabled
      @token = options[:token] || ENV['ONEVIEWSDK_TOKEN']
      @logger.warn 'User option not set. Using default (Administrator)' unless @token || options[:user] || ENV['ONEVIEWSDK_USER']
      @user = options[:user] || ENV['ONEVIEWSDK_USER'] || 'Administrator'
      @password = options[:password] || ENV['ONEVIEWSDK_PASSWORD']
      raise InvalidClient, 'Must set user & password options or token option' unless @token || @password
      @domain = options[:domain] || ENV['ONEVIEWSDK_DOMAIN'] || 'LOCAL'
      @token ||= login
    end

    def log_level=(level)
      @logger.level = @logger.class.const_get(level.upcase) rescue level
      @log_level = level
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
    # @param [String] variant API module variant to fetch resource from
    # @return [Array<Resource>] Results
    # @example Get all Ethernet Networks
    #   networks = @client.get_all('EthernetNetworks')
    #   synergy_networks = @client.get_all('EthernetNetworks', 300, 'Synergy')
    # @raise [TypeError] if the type is invalid
    def get_all(type, api_ver = @api_version, variant = nil)
      klass = OneviewSDK.resource_named(type, api_ver, variant)
      raise TypeError, "Invalid resource type '#{type}'. OneviewSDK::API#{api_ver} does not contain a class like it." unless klass
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

    # Refresh the client's session token & max_api_version.
    # Call this after a token expires or the user and/or password is updated on the client object.
    # @return [OneviewSDK::Client] self
    def refresh_login
      @max_api_version = appliance_api_version
      @token = login
      self
    end

    # Delete the session on the appliance, invalidating the client's token.
    # To generate a new token after calling this method, use the refresh_login method.
    # Call this after a token expires or the user and/or password is updated on the client object.
    # @return [OneviewSDK::Client] self
    def destroy_session
      response_handler(rest_delete('/rest/login-sessions'))
      self
    end

    # Creates the image streamer client object.
    # @param [Hash] options the options to configure the client
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :print_wait_dots (false) When true, prints status dots while waiting on the tasks to complete.
    # @option options [String] :url URL of Image Streamer
    # @option options [Integer] :api_version (300) This is the API version to use by default for requests
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests? Respects ENV['I3S_SSL_ENABLED']
    # @option options [Integer] :timeout (nil) Override the default request timeout value
    # @return [OneviewSDK::ImageStreamer::Client] New instance of image streamer client
    def new_i3s_client(options = {})
      OneviewSDK::ImageStreamer::Client.new(options.merge(token: @token))
    end


    private

    # Get current api version from the OneView appliance
    def appliance_api_version
      options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => :none }
      response = rest_api(:get, '/rest/version', options)
      version = response_handler(response)['currentVersion']
      raise ConnectionError, "Couldn't get API version" unless version
      version = version.to_i if version.class != Fixnum
      version
    rescue ConnectionError
      @logger.warn "Failed to get OneView max api version. Using default (#{OneviewSDK::DEFAULT_API_VERSION})"
      OneviewSDK::DEFAULT_API_VERSION
    end

    # Log in to OneView appliance and return the session token
    def login(retries = 2)
      options = {
        'body' => {
          'userName' => @user,
          'password' => @password,
          'authLoginDomain' => @domain
        }
      }
      response = rest_post('/rest/login-sessions', options)
      body = response_handler(response)
      return body['sessionID'] if body['sessionID']
      raise ConnectionError, "\nERROR! Couldn't log into OneView server at #{@url}. Response: #{response}\n#{response.body}"
    rescue StandardError => e
      raise e unless retries > 0
      @logger.debug 'Failed to log in to OneView. Retrying...'
      return login(retries - 1)
    end
  end
end
