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

require_relative 'version'
require_relative 'exceptions'
require_relative 'image-streamer/client'
require_relative 'resource'
Dir[File.dirname(__FILE__) + '/image-streamer/resource/*.rb'].each { |file| require file }

# Module for interacting with the HPE OneView API
module OneviewSDK
  # Module for interacting with the Image Streamer
  module ImageStreamer
    SUPPORTED_API_VERSIONS = [300, 500, 600].freeze
    DEFAULT_API_VERSION = 300
    @api_version = DEFAULT_API_VERSION
    @api_version_updated = false # Whether or not the API version has been set by the user

    # Get the current API version
    def self.api_version
      @api_version
    end

    # Set the default API version
    def self.api_version=(version)
      version = version.to_i rescue version
      raise "API version #{version} is not supported!" unless SUPPORTED_API_VERSIONS.include?(version)
      raise "The module for API version #{@api_version} is undefined" unless constants.include?("API#{@api_version}".to_sym)
      @api_version_updated = true
      @api_version = version
    end

    # Has the API version been set by the user?
    # @return [TrueClass, FalseClass]
    def self.api_version_updated?
      @api_version_updated
    end

    # Helps redirect resources to the correct API module for Image Streamer
    def self.const_missing(const)
      api_module = OneviewSDK::ImageStreamer.const_get("API#{@api_version}")
      api_module.const_get(const)
    rescue NameError
      raise NameError, "The #{const} method or resource does not exist for Image Streamer API version #{@api_version}."
    end

    # Get resource class that matches the type given
    # @param [String] type Name of the desired class type
    # @param [Fixnum] api_ver API module version to fetch resource from
    # @param [String] variant API module variant to fetch resource from
    # @return [Class] Resource class or nil if not found
    def self.resource_named(type, api_ver = @api_version, variant = nil)
      unless SUPPORTED_API_VERSIONS.include?(api_ver)
        raise UnsupportedVersion, "API version #{api_ver} is not supported! Try one of: #{SUPPORTED_API_VERSIONS}"
      end
      api_module = OneviewSDK::ImageStreamer.const_get("API#{api_ver}")
      variant ? api_module.resource_named(type, variant) : api_module.resource_named(type)
    end
  end
end
