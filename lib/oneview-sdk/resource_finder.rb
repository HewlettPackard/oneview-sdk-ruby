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

    # This overrides the :new method, returning an instance of the correct resource class.
    def self.new(client, options = {}, api_ver = nil)
      get_resource_class(api_ver || client.api_version).new(client, options, api_ver)
    end

    # Proxy class methods back to the correct resource class.
    def self.method_missing(method, *args, &block)
      client = args.first
      if client && client.is_a?(OneviewSDK::Client)
        get_resource_class(client.api_version).send(method, *args, &block)
      else
        get_resource_class.send(method, *args, &block)
      end
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
