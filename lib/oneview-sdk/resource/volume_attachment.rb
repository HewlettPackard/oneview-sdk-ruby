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
