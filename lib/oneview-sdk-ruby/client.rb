require 'logger'
require_relative 'config_loader'
require_relative 'rest'

module OneviewSDK
  # The client defines the connection to the OneView server and handles the communication with it.
  class Client
    DEFAULT_API_VERSION = 200

    attr_reader :url, :user, :token, :password, :max_api_version
    attr_accessor :ssl_enabled, :api_version, :logger, :log_level

    include Rest

    # Create client object, establish connection, and set up logging and api version.
    # @param [Hash] options the options to configure the client
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [String] :url URL of OneView appliance
    # @option options [String] :user ('Administrator') Username to use for authentication with OneView appliance
    # @option options [String] :password (ENV['ONEVIEWSDK_PASSWORD']) Password to use for authentication with OneView appliance
    # @option options [Integer] :api_version (200) API Version to use by default for requests
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests?
    def initialize(options)
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| fail "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
      @url = options[:url] || ENV['ONEVIEWSDK_URL']
      fail 'Must set the url option' unless @url
      @max_api_version = appliance_api_version
      if options[:api_version] && options[:api_version].to_i > @max_api_version
        logger.warn "API version #{options[:api_version]} is greater than the appliance API version (#{@max_api_version})"
      end
      @api_version = options[:api_version] || [DEFAULT_API_VERSION, @max_api_version].min
      @ssl_enabled = true
      @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
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

    # Save current attribute data to OneView
    # @param [Resource] resource the object to save
    def save(resource)
      resource.client = self
      resource.save
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

    # Wait for a task to complete
    # @param [String] task_uri
    # @param [Boolean] print_dots Whether or not to print a dot after each wait iteration
    # @raise [RuntimeError] if the task resulted in an error or early termination.
    # @return [Hash] if the task completed sucessfully, return the task details
    def wait_for(task_uri, print_dots = false)
      fail 'Must specify a task_uri!' if task_uri.nil? || task_uri.empty?
      loop do
        task = rest_get(task_uri)
        case task['taskState'].downcase
        when 'completed'
          return task
        when 'error', 'killed', 'terminated'
          msg = "Task ended with bad state: '#{task['taskState']}'.\nResponse: "
          if task['taskErrors']
            msg += JSON.pretty_generate(task['taskErrors'])
          else
            msg += JSON.pretty_generate(task)
          end
          fail(msg)
        else
          print '.' if print_dots
          sleep 10
        end
      end
    end

    private

    # Get current api version from the OneView appliance
    def appliance_api_version
      options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => :none }
      version = rest_api(:get, '/rest/version', options)['currentVersion']
      fail "Couldn't get API version" unless version
      version = version.to_i if version.class != Fixnum
      version
    rescue
      @logger.warn "Failed to get OneView max api version. Setting to default (#{DEFAULT_API_VERSION})"
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
      return response['sessionID'] if response['sessionID']
      if retries > 0
        @logger.debug "Failed to log in to OneView: #{response['message'] if response['message']} Retrying..."
        return login(retries - 1)
      else
        fail("\nERROR! Couldn't log into OneView server at #{@url}. Response:\n#{response}")
      end
    end
  end
end
