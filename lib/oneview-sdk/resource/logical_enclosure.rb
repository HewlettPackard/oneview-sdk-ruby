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

module OneviewSDK
  # Logical enclosure resource implementation
  class LogicalEnclosure < Resource
    BASE_URI = '/rest/logical-enclosures'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'LogicalEnclosure'
    end

    # @!group Validates

    VALID_FABRIC_TYPES = %w(DirectAttach FabricAttach).freeze
    # Validate fabricType
    # @param [String] value DirectAttach, FabricAttach
    # @raise [RuntimeError] if value is not 'DirectAttach' or 'FabricAttach'
    def validate_fabricType(value)
      fail 'Invalid fabric type' unless VALID_FABRIC_TYPES.include?(value)
    end

    # @!endgroup

    # Reapplies the appliance's configuration on enclosures
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the reapply fails
    # @return [LogicalEnclosure] self
    def reconfigure
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/configuration", {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Makes this logical enclosure consistent with the enclosure group
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the process fails
    # @return [Resource] self
    def update_from_group
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/updateFromGroup", {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Get the configuration script
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if retrieving fails
    # @return [String] script
    def get_script
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/script", @api_version)
      response.body
    end

    # Updates the configuration script for the logical enclosure
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the reapply fails
    # @return [Resource] self
    def set_script(script)
      ensure_client && ensure_uri
      response = @client.rest_put("#{@data['uri']}/script", { 'body' => script }, @api_version)
      @client.response_handler(response)
      self
    end

    # Generates a support dump for the logical enclosure
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the uri is not set
    # @raise [RuntimeError] if the process fails when generating the support dump
    # @return [Resource] self
    def support_dump(options)
      ensure_client && ensure_uri
      response = @client.rest_post("#{@data['uri']}/support-dumps", { 'body' => options }, @api_version)
      @client.wait_for(response.header['location'])
      self
    end

  end
end
