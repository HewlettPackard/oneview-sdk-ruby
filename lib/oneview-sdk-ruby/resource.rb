require_relative 'client'

# OneviewSDK Resources
module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    BASE_URI = nil # Overridden in individual resource classes

    attr_accessor \
      :client,
      :data,
      :api_version,
      :logger,
      :base_uri # Use only for undefined resources (this class)

    # Create client object, establish connection, and set up logging and api version.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    #   Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
    def initialize(client, params = {}, api_ver = nil)
      @client = client
      @logger = @client.logger
      @api_version = api_ver || @client.api_version
      if @api_version > @client.max_api_version
        fail "#{self.class.name} api_version '#{@api_version}' is greater than the client's max_api_version '#{@client.max_api_version}'"
      end
      @data ||= {}
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
      recursive_like?(other, @data)
    end

    # Create the resource on OneView using the current data
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI || @base_uri, { 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Create the resource on OneView using the current data even if it exists
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create!
      temp = self.class.new(@client, @data)
      temp.delete if temp.retrieve!
      create
    end

    # Updates this object using the data that exists on OneView
    # @return [Resource] self
    def refresh
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'], @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Save current data to OneView
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def save
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'], { 'body' => @data }, @api_version)
      @client.response_handler(response)
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
      response = @client.rest_delete(@data['uri'], {}, @api_version)
      @client.response_handler(response)
      true
    end

    # Save resource to .json or .yaml file
    # @param [String] file_path The full path to the file
    # @param [Symbol] format The format. Options: [:json, :yml]
    # @note If a .yml or .yaml file extension is given, the format will be set automatically
    # @return [True] The Resource was saved successfully
    def to_file(file_path, format = :json)
      format = :yml if %w(.yml .yaml).include? File.extname(file_path)
      temp_data = { type: self.class.name, api_version: @api_version, data: @data }
      case format.to_sym
      when :json
        File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(temp_data)) }
      when :yml, :yaml
        File.open(file_path, 'w') { |f| f.write(temp_data.to_yaml) }
      else
        fail "Invalid format: #{format}"
      end
      true
    end

    # Get resource schema
    # @return [Hash] Schema
    def schema
      self.class.schema(@client)
    end

    # Get resource schema
    # @param [Client] client
    # @return [Hash] Schema
    def self.schema(client)
      response = client.rest_get("#{self::BASE_URI}/schema", client.api_version)
      client.response_handler(response)
    rescue StandardError => e
      client.logger.error('This resource does not implement the schema endpoint!') if e.message.match(/404 NOT FOUND/)
      raise e
    end

    # Load resource from .json or .yaml file
    # @param [Client] client The client object to associate this resource with
    # @param [String] file_path The full path to the file
    # @return [Resource] New resource created from the file contents
    def self.from_file(client, file_path)
      resource = OneviewSDK::Config.load(file_path)
      class_name = resource['type'] ? Object.const_get(resource['type']) : self
      class_name.new(client, resource['data'], resource['api_version'])
    end

    # Make a GET request to the resource uri and return an array with results matching the search
    # @param [Client] client
    # @param [Hash] attributes Hash containing the attributes name and value
    # @return [Array<Resource>] Results matching the search
    def self.find_by(client, attributes)
      results = []
      uri = self::BASE_URI || @base_uri
      loop do
        response = client.rest_get(uri)
        body = client.response_handler(response)
        members = body['members']
        members.each do |member|
          temp = new(client, member)
          results.push(temp) if temp.like?(attributes)
        end
        break unless body['nextPageUri']
        uri = body['nextPageUri']
      end
      results
    end

    # Make a GET request to the resource uri and return an array with all objects of this type
    # @return [Array<Resource>] Results
    def self.get_all(client)
      find_by(client, {})
    end

    protected

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

    private

    # Recursive helper method for like?
    # Allows comparison of nested hash structures
    def recursive_like?(other, data = @data)
      fail "Can't compare with object type: #{other.class}! Must respond_to :each" unless other.respond_to?(:each)
      other.each do |key, val|
        return false unless data && data.respond_to?(:[])
        if val.is_a?(Hash)
          return false unless data.class == Hash && recursive_like?(val, data[key.to_s])
        else
          return false if val != data[key.to_s]
        end
      end
      true
    end

  end

  # Get resource class that matches the type given
  # @param [String] type Name of the desired class type
  # @return [Class] Resource class or nil if not found
  def self.resource_named(type)
    classes = {}
    orig_classes = []
    ObjectSpace.each_object(Class).select { |klass| klass < OneviewSDK::Resource }.each do |c|
      name = c.name.split('::').last
      orig_classes.push(name)
      classes[name.downcase.delete('_').delete('-')] = c
      classes["#{name.downcase.delete('_').delete('-')}s"] = c
    end
    new_type = type.to_s.downcase.delete('_').delete('-')
    return classes[new_type] if classes.keys.include?(new_type)
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
