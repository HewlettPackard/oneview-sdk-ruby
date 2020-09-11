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
require_relative 'image-streamer/client'

# OneviewSDK Resources
module OneviewSDK
  # Resource base class that defines all common resource functionality.
  class Resource
    BASE_URI = '/rest'.freeze
    UNIQUE_IDENTIFIERS = %w[name uri].freeze # Ordered list of unique attributes to search by
    DEFAULT_REQUEST_HEADER = {}.freeze

    attr_accessor \
      :client,
      :data,
      :api_version,
      :logger

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    #   Defaults to the client.api_version if it exists, or  Appliance's max API version to be used by default for requests
    def initialize(client, params = {}, api_ver = nil)
      raise InvalidClient, 'Must specify a valid client'\
        unless client.is_a?(OneviewSDK::Client) || client.is_a?(OneviewSDK::ImageStreamer::Client)
      @client = client
      @logger = @client.logger
      @api_version = api_ver || @client.api_version
      if @api_version > @client.max_api_version
        raise UnsupportedVersion,
              "#{self.class.name} api_version '#{@api_version}' is greater than the client's max_api_version '#{@client.max_api_version}'"
      end
      @data ||= {}
      set_all(params)
    end

    # Retrieve resource details based on this resource's name or URI.
    # @note one of the UNIQUE_IDENTIFIERS, e.g. name or uri, must be specified in the resource
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Boolean] Whether or not retrieve was successful
    def retrieve!(header = self.class::DEFAULT_REQUEST_HEADER)
      retrieval_keys = self.class::UNIQUE_IDENTIFIERS.reject { |k| @data[k].nil? }
      raise IncompleteResource, "Must set resource #{self.class::UNIQUE_IDENTIFIERS.join(' or ')} before trying to retrieve!" if retrieval_keys.empty?
      retrieval_keys.each do |k|
        results = self.class.find_by(@client, { k => @data[k] }, self.class::BASE_URI, header)
        next if results.size != 1
        set_all(results[0].data)
        return true
      end
      false
    end

    # Check if a resource exists
    # @note one of the UNIQUE_IDENTIFIERS, e.g. name or uri, must be specified in the resource
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Boolean] Whether or not resource exists
    def exists?(header = self.class::DEFAULT_REQUEST_HEADER)
      retrieval_keys = self.class::UNIQUE_IDENTIFIERS.reject { |k| @data[k].nil? }
      raise IncompleteResource, "Must set resource #{self.class::UNIQUE_IDENTIFIERS.join(' or ')} before trying to retrieve!" if retrieval_keys.empty?
      retrieval_keys.each do |k|
        results = self.class.find_by(@client, { k => @data[k] }, self.class::BASE_URI, header)
        return true if results.size == 1
      end
      false
    end

    # Merges the first hash data structure with the second
    # @note both arguments should be a Ruby Hash object.
    #       The second hash should have strings as a keys.
    #       This method will change the second argument.
    # @raise [StandardError] if the arguments, or one them, is not a Hash object
    def deep_merge!(other_data, target_data = @data)
      raise 'Both arguments should be a object Hash' unless other_data.is_a?(Hash) && target_data.is_a?(Hash)
      other_data.each do |key, value|
        value_target = target_data[key.to_s]
        if value_target.is_a?(Hash) && value.is_a?(Hash)
          deep_merge!(value, value_target)
        else
          target_data[key.to_s] = value
        end
      end
    end

    # Set the given hash of key-value pairs as resource data attributes
    # @param [Hash, Resource] params The options for this resource (key-value pairs or resource object)
    # @note All top-level keys will be converted to strings
    # @return [Resource] self
    def set_all(params = self.class::DEFAULT_REQUEST_HEADER)
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
    # @param [Resource] other The other resource to check for equality
    # @return [Boolean] Whether or not the two objects are equal
    def eql?(other)
      self == other
    end

    # Check the equality of the data for the other resource with this resource.
    # @note Does not check the client, logger, or api_version if another resource is passed in
    # @param [Hash, Resource] other resource or hash to compare the key-value pairs with
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
    # @param [Hash] header The header options for the request (key-value pairs)
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [Resource] self
    def create(header = self.class::DEFAULT_REQUEST_HEADER)
      ensure_client
      options = {}.merge(header).merge('body' => @data)
      response = @client.rest_post(self.class::BASE_URI, options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Delete the resource from OneView if it exists, then create it using the current data
    # @note Calls refresh method to set additional data
    # @param [Hash] header The header options for the request (key-value pairs)
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [Resource] self
    def create!(header = self.class::DEFAULT_REQUEST_HEADER)
      temp = self.class.new(@client, @data)
      temp.delete(header) if temp.retrieve!(header)
      create(header)
    end

    # Updates this object using the data that exists on OneView
    # @note Will overwrite any data that differs from OneView
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Resource] self
    def refresh(header = self.class::DEFAULT_REQUEST_HEADER)
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'], header, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Set data and save to OneView
    # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
    # @param [Hash] header The header options for the request (key-value pairs)
    # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
    # @raise [StandardError] if the resource save fails
    # @return [Resource] self
    def update(attributes = {}, header = self.class::DEFAULT_REQUEST_HEADER)
      set_all(attributes)
      ensure_client && ensure_uri
      options = {}.merge(header).merge('body' => @data)
      response = @client.rest_put(@data['uri'], options, @api_version)
      @client.response_handler(response)
      self
    end

    # Delete resource from OneView
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [true] if resource was deleted successfully
    def delete(header = self.class::DEFAULT_REQUEST_HEADER)
      ensure_client && ensure_uri
      response = @client.rest_delete(@data['uri'], header, @api_version)
      @client.response_handler(response)
      true
    end

    # Save resource to json or yaml file
    # @param [String] file_path The full path to the file
    # @param [Symbol] format The format. Options: [:json, :yml, :yaml]. Defaults to .json
    # @note If a .yml or .yaml file extension is given in the file_path, the format will be set automatically
    # @return [True] The Resource was saved successfully
    def to_file(file_path, format = :json)
      format = :yml if %w[.yml .yaml].include? File.extname(file_path)
      temp_data = { type: self.class.name, api_version: @api_version, data: @data }
      case format.to_sym
      when :json
        File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(temp_data)) }
      when :yml, :yaml
        File.open(file_path, 'w') { |f| f.write(temp_data.to_yaml) }
      else
        raise InvalidFormat, "Invalid format: #{format}"
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
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @return [Hash] Schema
    def self.schema(client)
      response = client.rest_get("#{self::BASE_URI}/schema", {}, client.api_version)
      client.response_handler(response)
    rescue StandardError => e
      client.logger.error('This resource does not implement the schema endpoint!') if e.message =~ /404 NOT FOUND/
      raise e
    end

    # Load resource from a .json or .yaml file
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] file_path The full path to the file
    # @return [Resource] New resource created from the file contents
    def self.from_file(client, file_path)
      resource = OneviewSDK::Config.load(file_path)
      klass = self
      if klass == OneviewSDK::Resource && resource['type'] # Use correct resource class by parsing type
        klass = OneviewSDK # Secondary/temp class/module reference
        resource['type'].split('::').each do |id|
          c = klass.const_get(id) rescue nil
          klass = c if c.is_a?(Class) || c.is_a?(Module)
        end
        klass = OneviewSDK::Resource unless klass <= OneviewSDK::Resource
      end
      klass.new(client, resource['data'], resource['api_version'])
    end

    # Make a GET request to the resource uri, and returns an array with results matching the search
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] attributes Hash containing the attributes name and value
    # @param [String] uri URI of the endpoint
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Array<Resource>] Results matching the search
    def self.find_by(client, attributes, uri = self::BASE_URI, header = self::DEFAULT_REQUEST_HEADER)
      all = find_with_pagination(client, uri, header)
      results = []
      all.each do |member|
        temp = new(client, member)
        results.push(temp) if temp.like?(attributes)
      end
      results
    end

    # Make a GET request to the uri, and returns an array with all results (search using resource pagination)
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] uri URI of the endpoint
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Array<Hash>] Results
    def self.find_with_pagination(client, uri, header = self::DEFAULT_REQUEST_HEADER)
      all = []
      loop do
        response = client.rest_get(uri, header)
        body = client.response_handler(response)
        members = body['members']
        break unless members
        all.concat(members)
        break unless body['nextPageUri'] && (body['nextPageUri'] != body['uri'])
        uri = body['nextPageUri']
      end
      all
    end

    # Make a GET request to the resource base uri, and returns an array with all objects of this type
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Array<Resource>] Results
    def self.get_all(client, header = self::DEFAULT_REQUEST_HEADER)
      find_by(client, {}, self::BASE_URI, header)
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
        words = k.to_s.split('_')
        words.map!(&:capitalize!)
        words[0] = words.first.downcase
        new_key = words.join
        v = "'" + v.join(',') + "'" if v.is_a?(Array) && v.any?
        v.retrieve! if v.respond_to?(:retrieve!) && !v['uri']
        if v.class <= OneviewSDK::Resource
          new_key = new_key.concat('Uri')
          v = v['uri']
        end
        query_path.concat("&#{new_key}=#{v}")
      end
      query_path.sub('?&', '?')
    end

    # Make a GET request to the resource base uri, query parameters and returns an array with all objects of this type
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] query The query options for the request (key-value pairs)
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [Array<Resource>] Results
    def self.get_all_with_query(client, query = nil)
      query_uri = build_query(query) if query
      find_with_pagination(client, "#{self::BASE_URI}/#{query_uri}")
    end

    protected

    # Fail unless @client is set for this resource.
    def ensure_client
      raise IncompleteResource, 'Please set client attribute before interacting with this resource' unless @client
      true
    end

    # Fail unless @data['uri'] is set for this resource.
    def ensure_uri
      raise IncompleteResource, 'Please set uri attribute before interacting with this resource' unless @data['uri']
      true
    end

    # Gets all the URIs for the specified resources
    # @param [Array<OneviewSDK::Resource>] resources The list of resources
    # @return [Array<String>] List of uris
    # @raise IncompleteResource if 'uri' is not set for each resource.
    def ensure_and_get_uris(resources)
      resources.map do |resource|
        resource.ensure_uri
        resource['uri']
      end
    end

    # Fail for methods that are not available for one resource
    def unavailable_method
      raise MethodUnavailable, "The method ##{caller(1..1).first[/`.*'/][1..-2]} is unavailable for this resource"
    end

    private

    # Recursive helper method for like?
    # Allows comparison of nested hash structures
    def recursive_like?(other, data = @data)
      raise "Can't compare with object type: #{other.class}! Must respond_to :each" unless other.respond_to?(:each)
      other.each do |key, val|
        return false unless data && data.respond_to?(:[])
        if val.is_a?(Hash)
          return false unless data.class == Hash && recursive_like?(val, data[key.to_s])
        elsif val.is_a?(Array) && val.first.is_a?(Hash)
          data_array = data[key.to_s] || data[key.to_sym]
          return false unless data_array.is_a?(Array)
          val.each do |other_item|
            return false unless data_array.find { |data_item| recursive_like?(other_item, data_item) }
          end
        elsif val.to_s != data[key.to_s].to_s && val.to_s != data[key.to_sym].to_s
          return false
        end
      end
      true
    end

  end

  # Get resource class that matches the type given
  # @param [String] type Name of the desired class type
  # @param [Fixnum] api_ver API module version to fetch resource from
  # @param [String] variant API module variant to fetch resource from
  # @return [Class] Resource class or nil if not found
  def self.resource_named(type, api_ver = @api_version, variant = nil)
    raise UnsupportedVersion, "API version #{api_ver} is not supported! Try one of: #{SUPPORTED_API_VERSIONS}"\
      unless SUPPORTED_API_VERSIONS.include?(api_ver)
    api_module = OneviewSDK.const_get("API#{api_ver}")
    variant ? api_module.resource_named(type, variant) : api_module.resource_named(type)
  end
end
