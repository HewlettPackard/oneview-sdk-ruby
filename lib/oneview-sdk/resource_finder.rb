# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'client'
require 'set'

# OneviewSDK Resources
module OneviewSDK
  # This class is a proxy class to determine the correct resource class based on the client's API version.
  # It will forward all requests to the correct class or fail if a valid class doesn't exist.
  class ResourceFinder
    attr_accessor :target

    # Create a resource object, associate it with a client, and set its properties.
    # The resource version will be determined by the api_version attribute or client's api version
    # and the target will be set to the newly created resource.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interacting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      if client && client.is_a?(OneviewSDK::Client)
        klass = self.class.get_resource_class(api_ver || client.api_version)
      else
        klass = self.class.get_resource_class(api_ver)
      end
      @target = klass.new(client, params, api_ver)
    end

    # Proxy instance methods back to the target
    def method_missing(name, *args, &block)
      @target.public_send(name, *args, &block)
    end

    # Proxy class methods back to the correct resource class.
    def self.method_missing(name, *args, &block)
      client = args.first
      if client && client.is_a?(OneviewSDK::Client)
        get_resource_class(client.api_version).public_send(name, *args, &block)
      else
        get_resource_class.public_send(name, *args, &block)
      end
    end

    # This method will help redirect to resources. It should NOT be called directly.
    # WARNING: It has no way of determining which API version the user is referring to, so tries the default,
    # and if it can't find it there, it returns the next available match
    def self.const_missing(const)
      get_resource_class.const_get(const)
    end

    # This gets the correct resource class
    # @param [OneviewSDK::Client] client
    # @param [Fixnum] api_ver Used to locate the resource within the namespace for this API version
    # @raise [OneviewSDK::InvalidResource] if a matching resource class cannot be found.
    # @return [OneviewSDK::Resource] The matching class
    def self.get_resource_class(api_ver = OneviewSDK::Client::DEFAULT_API_VERSION)
      api_module = OneviewSDK.const_get("API#{api_ver}")
      api_module.const_get(name.split('::').last)
    rescue NameError
      raise InvalidResource, "The #{name.split('::').last} resource does not exist for OneView API version #{api_ver}."
    end
  end

  # Create resource_finder subclasses for all resources defined in API modules
  classes = Set.new
  constants.select { |c| c.match(/^API\d+$/) }.each do |c|
    const_get(c).constants.each { |r| classes.add(r) }
  end
  classes.each { |klass_name| const_set(klass_name, Class.new(ResourceFinder)) }
end
