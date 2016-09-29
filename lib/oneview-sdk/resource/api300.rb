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
    SUPPORTED_API300_VERSIONS = %w(C7000 Thunderbird).freeze
    DEFAULT_API300_VERSION = 'C7000'.freeze
    @api300_version = DEFAULT_API300_VERSION
    @api300_version_updated = false # Whether or not the API version has been set by the user

    # Get the current API300 version
    def self.api300_version
      @api300_version
    end

    # Has the API300 version been set by the user?
    # @return [TrueClass, FalseClass]
    def self.api300_version_updated?
      @api300_version_updated
    end

    # Sets the API300 version
    def self.api300_version=(version)
      raise "API300 version #{version} is not supported!" unless SUPPORTED_API300_VERSIONS.include?(version)
      @api300_version_updated = true
      @api300_version = version
    end

    # Helps redirect resources to the correct API300 version
    def self.const_missing(const)
      api300_module = OneviewSDK::API300.const_get(@api300_version.to_s)
      api300_module.const_get(const)
    rescue NameError
      raise NameError, "The #{const} method or resource does not exist for OneView API300 version #{@api300_version}."
    end
  end
end

# Load all API300-specific resources:
Dir[File.dirname(__FILE__) + '/api300/*.rb'].each { |file| require file }
