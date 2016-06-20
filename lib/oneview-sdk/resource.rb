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

require_relative 'client'

# OneviewSDK Resources
module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    BASE_URI = '/rest'.freeze

    attr_accessor \
      :client,
      :data,
      :api_version,
      :logger

    # Create a resource object, associate it with a client, and set its properties.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    #   Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
    def initialize(client, params = {}, api_ver = nil)
      fail 'Must specify a valid client' unless client.is_a?(OneviewSDK::Client)
      @client = client
      @logger = @client.logger
      @api_version = api_ver || @client.api_version
      if @api_version > @client.max_api_version
        fail "#{self.class.name} api_version '#{@api_version}' is greater than the client's max_api_version '#{@client.max_api_version}'"
      end
      @data ||= {}
      set_all(params)
    end

    # Retrieve resource details based on this resource's name or URI.
    # @note Name or URI must be specified inside resource
    # @return [Boolean] Whether or not retrieve was successful
    def retrieve!
      fail 'Must set resource name or uri before trying to retrieve!' unless @data['name'] || @data['uri']
      results = self.class.find_by(@client, name: @data['name']) if @data['name']
      results = self.class.find_by(@client, uri:  @data['uri'])  if @data['uri'] && (!results || results.empty?)
      return false unless results.size == 1
      set_all(results[0].data)
      true
    end

    # Check if a resource exists
    # @note name or uri must be specified inside resource
    # @return [Boolean] Whether or not resource exists
    def exists?
      fail 'Must set resource name or uri before trying to retrieve!' unless @data['name'] || @data['uri']
      return true if @data['name'] && self.class.find_by(@client, name: @data['name']).size == 1
      return true if @data['uri']  && self.class.find_by(@client, uri:  @data['uri']).size == 1
      false
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
      send(method_name.to_sym, value) if respond_to?(method_name.to_sym)
      @data[key.to_s] = value
    end

    # Run block once for each data key-value pair
    def each(&block)
      @data.each(&block)
    end

    # Access data using hash syntax
    # @param [String, Symbol] key Name of key to get value for
    # @return The value of the given key. If not found, returns nil
    # @note The key will be converted to a string
    def [](key)
      @data[key.to_s]
    end

    # Set data using hash syntax
    # @param [String, Symbol] key Name of key to set the value for
    # @param [Object] value to set for the given key
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
    #   myResource = OneviewSDK::Resource.new(client, { name: 'res1', description: 'example'}, 200)
    #   myResource.like?(description: '') # returns false
    #   myResource.like?(name: 'res1') # returns true
    # @return [Boolean] Whether or not the two objects are alike
    def like?(other)
      recursive_like?(other, @data)
    end

    # Create the resource on OneView using the current data
    # @note Calls the refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Delete the resource from OneView if it exists, then create it using the current data
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
    # @note Will overwrite any data that differs from OneView
    # @return [Resource] self
    def refresh
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'], @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Set data and save to OneView
    # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
    # @raise [RuntimeError] if the client or uri is not set
    # @raise [RuntimeError] if the resource save fails
    # @return [Resource] self
    def update(attributes = {})
      set_all(attributes)
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'], { 'body' => @data }, @api_version)
      @client.response_handler(response)
      self
    end

    # Delete resource from OneView
    # @return [true] if resource was deleted successfully
    def delete
      ensure_client && ensure_uri
      response = @client.rest_delete(@data['uri'], {}, @api_version)
      @client.response_handler(response)
      true
    end

    # Save resource to json or yaml file
    # @param [String] file_path The full path to the file
    # @param [Symbol] format The format. Options: [:json, :yml, :yaml]. Defaults to .json
    # @note If a .yml or .yaml file extension is given in the file_path, the format will be set automatically
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
    # @note This may not be implemented in the API for every resource. Check the API docs
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
      client.logger.error('This resource does not implement the schema endpoint!') if e.message =~ /404 NOT FOUND/
      raise e
    end

    # Load resource from a .json or .yaml file
    # @param [Client] client The client object to associate this resource with
    # @param [String] file_path The full path to the file
    # @return [Resource] New resource created from the file contents
    def self.from_file(client, file_path)
      resource = OneviewSDK::Config.load(file_path)
      new(client, resource['data'], resource['api_version'])
    end

    # Make a GET request to the resource uri and return an array with results matching the search
    # @param [Client] client
    # @param [Hash] attributes Hash containing the attributes name and value
    # @param [String] uri URI of the endpoint
    # @return [Array<Resource>] Results matching the search
    def self.find_by(client, attributes, uri = self::BASE_URI)
      results = []
      loop do
        response = client.rest_get(uri)
        body = client.response_handler(response)
        members = body['members']
        break unless members
        members.each do |member|
          temp = new(client, member)
          results.push(temp) if temp.like?(attributes)
        end
        break unless body['nextPageUri'] && (body['nextPageUri'] != uri)
        uri = body['nextPageUri']
      end
      results
    end

    # Make a GET request to the resource base uri and return an array with all objects of this type
    # @return [Array<Resource>] Results
    def self.get_all(client)
      find_by(client, {})
    end

    # Builds a Query string corresponding to the parameters passed
    # @param [Hash{String=>String,OneviewSDK::Resource}] query_options Query parameters and values
    #   to be applied to the query url.
    #   All key values should be Strings in snake case, the values could be Strings or Resources.
    # @option query_options [String] String Values that are Strings can be associated as usual
    # @option query_options [String] Resources Values that are Resources can be associated as usual,
    #   with keys representing only the resource names (like 'ethernet_network'). This method
    #   translates the SDK and Ruby standards to OneView request standard.
    def self.build_query(query_options)
      return '' if !query_options || query_options.empty?
      query_path = '?'
      query_options.each do |k, v|
        new_key = snake_to_lower_camel(k)
        v.retrieve! if v.respond_to?(:retrieve!) && !v['uri']
        if v.class <= OneviewSDK::Resource
          new_key = new_key.concat('Uri')
          v = v['uri']
        end
        query_path.concat("&#{new_key}=#{v}")
      end
      query_path.sub('?&', '?')
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

    # Fail for methods that are not available for one resource
    def unavailable_method
      fail "The method ##{caller[0][/`.*'/][1..-2]} is unavailable for this resource"
    end

    private

    # Changes the case of a String from snake_case to lowerCamelCase
    # @param [String] str String in snake_case to be changed
    # @return [String] the String in lowerCamelCase
    def self.snake_to_lower_camel(str)
      words = str.split('_')
      words.map!(&:capitalize!)
      words[0] = words.first.downcase
      words.join
    end

    # Recursive helper method for like?
    # Allows comparison of nested hash structures
    def recursive_like?(other, data = @data)
      fail "Can't compare with object type: #{other.class}! Must respond_to :each" unless other.respond_to?(:each)
      other.each do |key, val|
        return false unless data && data.respond_to?(:[])
        if val.is_a?(Hash)
          return false unless data.class == Hash && recursive_like?(val, data[key.to_s])
        elsif val != data[key.to_s]
          return false
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
    new_type = type.to_s.downcase.gsub(/[ -_]/, '')
    return classes[new_type] if classes.keys.include?(new_type)
  end
end

# Load all resources:
Dir[File.dirname(__FILE__) + '/resource/*.rb'].each { |file| require file }
