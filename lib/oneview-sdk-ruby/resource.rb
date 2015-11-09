require_relative 'client'

module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    BASE_URI = '/rest'

    attr_accessor \
      :client,
      :data,
      :api_version,
      :logger

    # Create client object, establish connection, and set up logging and api version.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    #   Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
    def initialize(client, params = {}, api_ver = nil)
      @client = client
      @logger = @client.logger
      @api_version = api_ver || @client.api_version
      @data = {}
      set_all(params)
    end

    # Retrieve resource details based on this resource's name.
    # @note Name must be unique
    # @param [String] name Resource name
    # @return [Boolean] Whether or not retrieve was successful
    def retrieve!(name = @data['name'])
      fail 'Must set resource name before trying to retrieve!' unless name
      results = self.class.find_by(@client, name: name)
      return false unless results.size == 1
      set_all(results[0].data)
      true
    end

    # Set the given hash of key-value pairs as resource data attributes
    # @param [Hash, Resource] params The options for this resource (key-value pairs or Resource object)
    # @note All top-level keys will be converted to strings
    # @return [Resource] self
    def set_all(params = {})
      params = params.data if params.class <= Resource
      params = Hash[params.map { |(k, v)| [k.to_s, v] }]
      params.each { |key, value| set(key.to_s, value) }
      self
    end

    # Set a resource attribute with the given value and call any validation method if necessary
    # @param [String] key attribute name
    # @param value value to assign to the given attribute
    # @note Keys will be converted to strings
    def set(key, value)
      method_name = "validate_#{key}"
      send(method_name.to_sym, value) if self.respond_to?(method_name.to_sym)
      @data[key.to_s] = value
    end

    # Run block once for each data key-value pair
    def each(&block)
      @data.each(&block)
    end

    # Access data using hash syntax
    # @param [String, Symbol] key Name of key to get value for
    # @return The value of the given key. If not found, returns nil
    def [](key)
      @data[key.to_s]
    end

    # Set data using hash syntax
    # @param [String, Symbol] key Name of key to set the value for
    # @param [Object] key Value to set for the given key
    # @note The key will be converted to a string
    # @return The value set for the given key
    def []=(key, value)
      set(key, value)
      value
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

    # Check equality of data on other resource with that of this resource.
    # @note Doesn't check the client, logger, or api_version if another Resource is passed in
    # @param [Hash, Resource] other Resource or hash to compare key-value pairs with
    # @example Compare to hash
    #   myResource = OneviewSDK::Resource.new({ name: 'res1', description: 'example'}, client, 200)
    #   myResource.like?(name: '', api_version: 200) # returns true
    # @return [Boolean] Whether or not the two objects are alike
    def like?(other)
      fail "Can't compare with object type: #{other.class}! Must respond_to :each" unless other.respond_to?(:each)
      other.each { |key, val| return false if val != @data[key.to_s] }
      true
    end

    # Create the resource on OneView using the current data
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'body' => @data }, @api_version)
      response = @client.response_handler(response)
      set_all(response)
      self
    end

    # Updates this object using the data that exists on OneView
    # @return [Resource] self
    def refresh
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'], @api_version)
      set_all(response)
      self
    end

    # Save current data to OneView
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def save
      ensure_client && ensure_uri
      task = @client.rest_put(@data['uri'], { 'body' => @data }, @api_version)
      fail "Failed to save #{self.class}\n Response: #{task}" unless task['uri'] || task['location']
      @client.wait_for(task['uri'] || task['location'])
      self
    end

    # Set data and save to OneView
    # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def update(attributes = {})
      set_all(attributes)
      save
    end

    # Delete resource from OneView
    # @return [true] if resource was deleted successfully
    def delete
      ensure_client && ensure_uri
      task = @client.rest_delete(@data['uri'], @api_version)
      fail "Failed to delete #{self.class}\n Response: #{task}" unless task['uri'] || task['location']
      @client.wait_for(task['uri'] || task['location'])
      true
    end

    # Make a GET request to the resource uri and return an array with results matching the search
    # @param [Hash] attributes Hash containing the attributes name and value
    # @return [Array<Resource>] Results matching the search
    def self.find_by(client, attributes)
      results = []
      uri = self::BASE_URI
      loop do
        response = JSON.parse(client.rest_get(uri).body)
        members = response['members']
        members.each do |member|
          temp = new(client, member)
          results.push(temp) if temp.like?(attributes)
        end
        break unless response['nextPageUri']
        uri = response['nextPageUri']
      end
      results
    end


    private

    # Fail unless @client is set for this resource.
    def ensure_client
      fail 'Please set client attribute before interacting with this resource' unless @client
      true
    end

    # Fail unless @data['uri'] is set for this resource.
    def ensure_uri
      fail 'Please set uri attribute before interacting with this resource' unless @data['uri']
      true
    end
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
