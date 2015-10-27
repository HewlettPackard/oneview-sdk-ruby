require_relative 'client'

module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    BASE_URI = '/rest'

    attr_accessor \
      :client,
      :uri,
      :api_version

    # Create client object, establish connection, and set up logging and api version.
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    #   Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
    def initialize(params = {}, client = nil, api_ver = nil)
      @client ||= client if client
      @logger = @client ? @client.logger : Logger.new(STDOUT)
      set_all(params)
      api_ver ||= @client.api_version if @client
      @api_version ||= api_ver || OneviewSDK::Client::DEFAULT_API_VERSION
    end

    def set_all(params = {})
      reserved_methods = %w(create delete save update refresh each to_hash eql? like?)
      params.each do |key, value|
        if reserved_methods.include?(key.to_s)
          @logger.warn "Can't set attribute '#{key}' because that's a reserved method"
        else
          instance_variable_set("@#{key}", value)
          self.class.send(:attr_accessor, key)
        end
      end
    end

    # Run block once for each key-value pair (excludes @client & @logger keys)
    def each(&block)
      to_hash.each(&block)
    end

    # Get a hash representation of the resource
    # @return [Hash] A hash representation of the resource. Excludes @client & @logger keys
    def to_hash
      ret_val = {}
      instance_variables.each do |key|
        ret_val["#{key[1..-1]}"] = instance_variable_get(key) unless key == :@client || key == :@logger
      end
      ret_val
    end

    # Access instance variables using hash syntax
    # @param [String, Symbol] key Name of key to get value for
    # @return The value of the given key. If not found, returns nil
    def [](key)
      instance_variable_get("@#{key}")
    end

    # Set instance variables using hash syntax
    # @param [String, Symbol] key Name of key to set the value for
    # @param [Object] key Value to set for the given key
    # @return The value set for the given key
    def []=(key, value)
      instance_variable_set("@#{key}", value)
    end

    # Check equality of 2 resources. Same as eql?(other)
    # @param [Resource] other The other resource to check equality for
    # @return [Boolean] Whether or not the two objects are equal
    def ==(other)
      self_state  = instance_variables.sort.map { |v| instance_variable_get(v) }
      other_state = other.instance_variables.sort.map { |v| other.instance_variable_get(v) }
      other.class == self.class && other_state == self_state
    end

    # Check equality of 2 resources. Same as ==(other)
    # @param [Resource] other The other resource to check equality for
    # @return [Boolean] Whether or not the two objects are equal
    def eql?(other)
      self == other
    end

    # Check equality of attributes set on other resource with those of this resource.
    # @note Doesn't check the client object if another resource is passed in
    # @param [Enumerable, Resource] other Resource or hash to compare key-value pairs with
    # @example Compare to hash
    #   myResource = OneviewSDK::Resource.new({ name: 'res1', description: 'example'}, client, 200)
    #   myResource.like?(name: '', api_version: 200) # returns true
    # @return [Boolean] Whether or not the two objects are alike
    def like?(other)
      fail "Can't compare with object type: #{other.class}! Must respond_to :each" unless other.respond_to?(:each)
      other.each { |key, val| return false if val != self[key] }
      true
    end

    # Create the resource on OneView using the current attribute data
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'body' => to_hash }, @api_version)
      fail "Failed to create #{self.class}\n Response: #{response}" unless response['uri']
      @uri = response['uri']
      refresh
      self
    end

    # Save current attribute data to OneView
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def save
      ensure_client && ensure_uri
      response = @client.rest_put(@uri, to_hash, @api_version)
      fail "Failed to save #{self.class}\n Response: #{response}" unless response['uri']
      self
    end

    # Set attribute data and save to OneView
    # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def update(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      save
    end

    # Updates this object using the data that exists on OneView
    # @return [Resource] self
    def refresh
      ensure_client && ensure_uri
      response = @client.rest_get(@uri, @api_version)
      # TODO: Set values accordingly
      self
    end

    # Delete resource from OneView
    # @return [true] if resource was deleted successfully
    def delete
      ensure_client && ensure_uri
      @client.rest_delete(@uri, @api_version)
    end

    # Make a GET request to the resource uri and return an array with results matching the search
    # @param [Hash] attributes Hash containing the attributes name and value
    # @return [Array<Resource>] Results matching the search
    def self.find_by(client, attributes)
      results = []
      members = client.rest_get(self.class::BASE_URI)['members']
      members.each do |member|
        temp = self.class.new(member)
        results.push(temp) if temp.like?(attributes)
      end
      results
    end


    private

    # Fail unless @client is set for this resource.
    def ensure_client
      fail 'Please set client attribute before interacting with this resource' unless @client
    end

    # Fail unless @uri is set for this resource.
    def ensure_uri
      fail 'Please set uri attribute before interacting with this resource' unless @uri
    end
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
