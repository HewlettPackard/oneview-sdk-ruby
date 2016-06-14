################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

module OneviewSDK
  # Storage Volume Attachment resource implementation
  class VolumeAttachment < Resource
    BASE_URI = '/rest/storage-volume-attachments'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StorageVolumeAttachment'
    end

    # unavailable method
    def create
      unavailable_method
    end

    # unavailable method
    def update
      unavailable_method
    end

    # unavailable method
    def delete
      unavailable_method
    end

    # Get the list of extra unmanaged storage volumes
    # @param [OneviewSDK::Client] client Oneview client
    def self.get_extra_unmanaged_volumes(client)
      response = client.rest_get(BASE_URI + '/repair?alertFixType=ExtraUnmanagedStorageVolumes')
      client.response_handler(response)
    end

    # Removes extra presentations from a specific server profile
    # @param [OneviewSDK::Client] client Oneview client
    # @param [OneviewSDK::Resource] resource Oneview resource
    def self.remove_extra_unmanaged_volume(client, resource)
      requestBody = {
        type: 'ExtraUnmanagedStorageVolumes',
        resourceUri: resource['uri']
      }
      response = client.rest_post(BASE_URI + '/repair', 'body' => requestBody)
      client.response_handler(response)
    end

    # Gets all volume attachment paths
    # @return [Array] List of StorageVolumeAttachmentPath
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
