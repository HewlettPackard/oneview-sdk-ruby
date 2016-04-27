require 'logger'
require_relative 'config_loader'
require_relative 'rest'
require_relative 'ssl_helper'

module OneviewSDK
  # The client defines the connection to the OneView server and handles communication with it.
  class Client
    DEFAULT_API_VERSION = 200

    attr_reader :url, :user, :token, :password, :max_api_version
    attr_accessor :ssl_enabled, :api_version, :logger, :log_level, :cert_store, :print_wait_dots

    include Rest

    # Create client object, establish connection, and set up logging and api version.
    # @param [Hash] options the options to configure the client
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :print_wait_dots (false) When true, prints status dots while waiting on tasks to complete.
    # @option options [String] :url URL of OneView appliance
    # @option options [String] :user ('Administrator') Username to use for authentication with OneView appliance
    # @option options [String] :password (ENV['ONEVIEWSDK_PASSWORD']) Password to use for authentication with OneView appliance
    # @option options [String] :token (ENV['ONEVIEWSDK_TOKEN']) Token to use for authentication with OneView appliance
    #   Use this OR the username and password (not both). Token has precedence.
    # @option options [Integer] :api_version (200) API Version to use by default for requests
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests? Respects ENV['ONEVIEWSDK_SSL_ENABLED']
    def initialize(options = {})
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| fail "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
      @print_wait_dots = options.fetch(:print_wait_dots, false)
      @url = options[:url] || ENV['ONEVIEWSDK_URL']
      fail 'Must set the url option' unless @url
      @max_api_version = appliance_api_version
      if options[:api_version] && options[:api_version].to_i > @max_api_version
        logger.warn "API version #{options[:api_version]} is greater than the appliance API version (#{@max_api_version})"
      end
      @api_version = options[:api_version] || [DEFAULT_API_VERSION, @max_api_version].min
      @ssl_enabled = true
      if ENV.key?('ONEVIEWSDK_SSL_ENABLED')
        if %w(true false 1 0).include?(ENV['ONEVIEWSDK_SSL_ENABLED'])
          @ssl_enabled = ! %w(false 0).include?(ENV['ONEVIEWSDK_SSL_ENABLED'])
        else
          @logger.warn "Unrecognized ssl_enabled value '#{ENV['ONEVIEWSDK_SSL_ENABLED']}'. Valid options are 'true' & 'false'"
        end
      end
      @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
      @cert_store = OneviewSDK::SSLHelper.load_trusted_certs if @ssl_enabled
      @token = options[:token] || ENV['ONEVIEWSDK_TOKEN']
      return if @token
      @logger.warn 'User option not set. Using default (Administrator)' unless options[:user] || ENV['ONEVIEWSDK_USER']
      @user = options[:user] || ENV['ONEVIEWSDK_USER'] || 'Administrator'
      @password = options[:password] || ENV['ONEVIEWSDK_PASSWORD']
      fail 'Must set user & password options or token option' unless @password
      @token = login
    end

    # Tell OneView to create the resource using the current attribute data
    # @param [Resource] resource the object to create
    def create(resource)
      resource.client = self
      resource.create
    end

    # Set attribute data and save to OneView
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
    # @return [Array<Resource>] Results
    # @example Get all Ethernet Networks
    #   networks = @client.get_all('EthernetNetworks')
    def get_all(type)
      OneviewSDK.resource_named(type).get_all(self)
    rescue StandardError
      raise "Invalid resource type '#{type}'"
    end

    # Wait for a task to complete
    # @param [String] task_uri
    # @raise [RuntimeError] if the task resulted in an error or early termination.
    # @return [Hash] if the task completed sucessfully, return the task details
    def wait_for(task_uri)
      fail 'Must specify a task_uri!' if task_uri.nil? || task_uri.empty?
      loop do
        task_uri.gsub!(%r{/https:(.*)\/rest/}, '/rest')
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
          fail(msg)
        else
          print '.' if @print_wait_dots
          sleep 10
        end
      end
    end


    private

    # Get current api version from the OneView appliance
    def appliance_api_version
      options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => :none }
      response = rest_api(:get, '/rest/version', options)
      version = response_handler(response)['currentVersion']
      fail "Couldn't get API version" unless version
      version = version.to_i if version.class != Fixnum
      version
    rescue
      @logger.warn "Failed to get OneView max api version. Using default (#{DEFAULT_API_VERSION})"
      DEFAULT_API_VERSION
    end

    # Log in to OneView appliance and set max_api_version
    def login(retries = 2)
      options = {
        'body' => {
          'userName' => @user,
          'password' => @password,
          'authLoginDomain' => 'LOCAL'
        }
      }
      response = rest_post('/rest/login-sessions', options)
      body = response_handler(response)
      return body['sessionID'] if body['sessionID']
      fail "\nERROR! Couldn't log into OneView server at #{@url}. Response: #{response}\n#{response.body}"
    rescue StandardError => e
      raise e unless retries > 0
      @logger.debug 'Failed to log in to OneView. Retrying...'
      return login(retries - 1)
    end
  end
end
