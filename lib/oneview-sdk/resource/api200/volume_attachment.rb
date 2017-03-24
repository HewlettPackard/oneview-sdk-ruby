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

require_relative 'resource'

module OneviewSDK
  module API200
    # Storage volume attachment resource implementation
    class VolumeAttachment < Resource
      BASE_URI = '/rest/storage-volume-attachments'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['type'] ||= 'StorageVolumeAttachment'
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def update(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Gets the list of extra unmanaged storage volumes
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      def self.get_extra_unmanaged_volumes(client)
        response = client.rest_get(BASE_URI + '/repair?alertFixType=ExtraUnmanagedStorageVolumes')
        client.response_handler(response)
      end

      # Removes extra presentations from a specific server profile
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [OneviewSDK::Resource] resource Oneview resource
      def self.remove_extra_unmanaged_volume(client, resource)
        requestBody = {
          type: 'ExtraUnmanagedStorageVolumes',
          resourceUri: resource['uri']
        }
        response = client.rest_post(BASE_URI + '/repair', { 'Accept-Language' => 'en_US', 'body' => requestBody }, client.api_version)
        client.response_handler(response)
      end

      # Gets all volume attachment paths
      # @return [Array] List of the storage volume attachments paths
      def get_paths
        response = @client.rest_get(@data['uri'] + '/paths')
        @client.response_handler(response)
      end

      # Gets a volume attachment path by id
      # @param [String] id Volume attachament path id
      # @return [OneviewSDK::VolumeAttachmentPath]
      def get_path(id)
        response = @client.rest_get("#{@data['uri']}/paths/#{id}")
        @client.response_handler(response)
      end
    end
  end
end
