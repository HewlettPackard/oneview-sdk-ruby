# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'resource'

module OneviewSDK
  module API200
    # User resource implementation
    class User < Resource
      BASE_URI = '/rest/users'.freeze
      UNIQUE_IDENTIFIERS = %w(userName uri).freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['type'] ||= 'UserAndRoles'
        @data['enabled'] ||= true
        @data['roles'] ||= ['Read only']
      end

      # Create the resource on OneView using the current data
      # @note Calls the refresh method to set additional data
      # @note Removes the password attribute after creation
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create
        ensure_client
        response = @client.rest_post(self.class::BASE_URI, { 'body' => @data }, @api_version)
        body = @client.response_handler(response)
        @data.delete('password')
        set_all(body)
        self
      end

      # Set data and save to OneView
      # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
      # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
      # @raise [StandardError] if the resource save fails
      # @return [Resource] self
      def update(attributes = {})
        set_all(attributes)
        ensure_client && ensure_uri
        new_data = @data.select { |k, _v| k.to_s != 'roles' } # This cannot be updated here. It is updated below
        response = @client.rest_put(self.class::BASE_URI, { 'body' => new_data }, @api_version)
        d = @client.response_handler(response)
        set_roles(@data['roles']) if @data['roles'] && @data['roles'].sort != d['roles'].sort
        self
      end

      # Set data and save to OneView
      # @param [Array] roles The names of the roles to set for this user
      # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
      # @raise [StandardError] if setting the role fails
      # @return [Resource] self
      def set_roles(roles)
        ensure_client && ensure_uri
        data = roles.map { |r| { roleName: r, type: 'RoleNameDtoV2' } }
        response = @client.rest_put("#{@data['uri']}/roles?multiResource=true", { 'body' => data }, @api_version)
        r = @client.response_handler(response)
        new_roles = r.map { |i| i['roleName'] }
        set('roles', new_roles)
        self
      end
    end
  end
end
