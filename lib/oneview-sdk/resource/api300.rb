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

module OneviewSDK
  # Module for API v300
  module API300
    SUPPORTED_VERSIONS = %w(C7000 Thunderbird).freeze
    DEFAULT_VERSION = 'C7000'.freeze
    @version = DEFAULT_VERSION
    @version_updated = false # Whether or not the API version has been set by the user

    # Get resource class that matches the type given
    # @param [String] type Name of the desired class type
    # @param [String] version Version (C7000 or Thunderbird)
    # @return [Class] Resource class or nil if not found
    def self.resource_named(type, version = @version)
      raise "API300 version #{version} is not supported!" unless SUPPORTED_VERSIONS.include?(version)
      new_type = type.to_s.downcase.gsub(/[ -_]/, '')
      api_module = OneviewSDK::API300.const_get(version)
      api_module.constants.each do |c|
        klass = api_module.const_get(c)
        next unless klass.is_a?(Class) && klass < OneviewSDK::Resource
        name = klass.name.split('::').last.downcase.delete('_').delete('-')
        return klass if new_type =~ /^#{name}[s]?$/
      end
      nil
    end

    # Get the current API300 version
    def self.version
      @version
    end

    # Has the API300 version been set by the user?
    # @return [TrueClass, FalseClass]
    def self.version_updated?
      @version_updated
    end

    # Sets the API300 version
    def self.version=(version)
      raise "API300 version #{version} is not supported!" unless SUPPORTED_VERSIONS.include?(version)
      @version_updated = true
      @version = version
    end

    # Helps redirect resources to the correct API300 version
    def self.const_missing(const)
      api300_module = OneviewSDK::API300.const_get(@version.to_s)
      api300_module.const_get(const)
    rescue NameError
      raise NameError, "The #{const} method or resource does not exist for OneView API300 version #{@version}."
    end
  end
end

# Load all API300-specific resources:
Dir[File.dirname(__FILE__) + '/api300/*.rb'].each { |file| require file }
