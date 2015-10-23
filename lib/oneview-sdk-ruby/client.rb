require 'logger'
require_relative 'rest'
Dir[File.dirname(__FILE__) + '/client/*.rb'].each { |file| require file }

module OneviewSDK
  # The client defines the connection to the OneView server and handles the communication with it.
  class Client
    DEFAULT_API_VERSION = 200

    attr_reader :url, :user, :token, :password, :max_api_version
    attr_accessor :ssl_enabled, :api_version, :logger, :log_level

    include Rest

    # Create client object, establish connection, and set up logging and api version.
    # @param [Hash] options the options to configure the client
    # @option options [String] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [String] :url URL of OneView appliance
    # @option options [String] :user ('Administrator') Username to use for authentication with OneView appliance
    # @option options [String] :password (ENV['ONEVIEWSDK_PASSWORD']) Password to use for authentication with OneView appliance
    # @option options [Integer] :api_version (200) API Version to use by default for requests
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests?
    def initialize(options)
      # TODO: fail unless all required options are present
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| fail "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase)
      @url = options[:url]
      fail 'Must set the url option' unless @url
      set_max_api_version
      if options[:api_version] && options[:api_version].to_i > @max_api_version
        logger.warn "API version #{options[:api_version]} is greater than the appliance API version (#{@max_api_version})"
      end
      @api_version = options[:api_version] || [DEFAULT_API_VERSION, @max_api_version].min
      @ssl_enabled = true
      @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
      @token = options[:token] || ENV['ONEVIEWSDK_TOKEN']
      @logger.warn 'User option not set. Using default (Administrator)' unless options[:user] || @token
      @user = options[:user] || 'Administrator'
      @password = options[:password] || ENV['ONEVIEWSDK_PASSWORD']
      fail 'Must set user & password options or token option' unless @password || @token
      @token ||= login
    end

    # Tell OneView to create the resource using the current attribute data
    def create(resource)
      resource.client = self
      resource.create
    end

    # Save current attribute data to OneView
    def save(resource)
      resource.client = self
      resource.save
    end

    # Set attribute data and save to OneView
    def update(resource, attributes = {})
      resource.client = self
      resource.update(attributes)
    end

    # Updates this object using the data that exists on OneView
    def refresh(resource)
      resource.client = self
      resource.refresh
    end

    def delete(resource)
      resource.client = self
      resource.delete
    end

    private

    # Set max api version from the OneView appliance
    def set_max_api_version
      options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => :none }
      version = rest_api(:get, '/rest/version', options)['currentVersion']
      fail "Couldn't get API version" unless version
      version = version.to_i if version.class != Fixnum
      @max_api_version = version
    rescue
      @logger.warn "Failed to get OneView max api version. Setting to default (#{DEFAULT_API_VERSION})"
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
      return response['sessionID'] if response['sessionID']
      if retries > 0
        @logger.debug "Failed to log in to OneView: #{response['message'] if response['message']} Retrying..."
        return login(retries - 1)
      else
        fail("\nERROR! Couldn't log into OneView server at #{@oneview_base_url}. Response:\n#{response}")
      end
    end
  end
end
