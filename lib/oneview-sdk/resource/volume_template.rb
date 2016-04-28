module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   category
  #   created
  #   description
  #   eTag
  #   modified
  #   name
  #   provisioning
  #     capacity
  #     provisionType
  #     shareable
  #     storagePoolUri
  #   refreshState
  #   state
  #   stateReason
  #   status
  #   storageSystemUri
  #   type
  #   uri
  class VolumeTemplate < Resource
    BASE_URI = '/rest/storage-volume-templates'.freeze

    # Create client object, establish connection, and set up logging and api version.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    # Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
    # Defaults type to StorageVolumeTemplate when API version is 120
    # Defaults type to StorageVolumeTemplateV3 when API version is 200
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['provisioning'] ||= {}
      @data['type'] ||= 'StorageVolumeTemplateV3'
    end

    # @!group Validates

    VALID_REFRESH_STATES = %w(NotRefreshing RefreshFailed RefreshPending Refreshing).freeze
    # Validate refreshState
    # @param [String] value NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    def validate_refreshState(value)
      fail 'Invalid refresh state' unless VALID_REFRESH_STATES.include?(value)
    end

    VALID_STATUSES = %w(OK Disabled Warning Critical Unknown).freeze
    # Validate status
    # @param [String] value OK, Disabled, Warning, Critical, Unknown
    def validate_status(value)
      fail 'Invalid status' unless VALID_STATUSES.include?(value)
    end

    # @!endgroup

    # Create the resource on OneView using the current data
    # Adds Accept-Language attribute in the Header equal to "en_US"
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'Accept-Language' => 'en_US', 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Delete volume template from OneView
    # Adds Accept-Language attribute in the Header equal to "en_US"
    # @return [TrueClass] if volume template was deleted successfully
    def delete
      ensure_client && ensure_uri
      response = @client.rest_delete(@data['uri'], { 'Accept-Language' => 'en_US' }, @api_version)
      @client.response_handler(response)
      true
    end

    # Update volume template from OneView
    # Adds Accept-Language attribute in the Header equal to "en_US"
    # @return [Resource] self
    def update(attributes = {})
      set_all(attributes)
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'], { 'Accept-Language' => 'en_US', 'body' => @data }, @api_version)
      @client.response_handler(response)
      self
    end

    # Set storage pool
    # @param [Boolean] shareable
    # @param [String] provisionType. Options: ['Thin', 'Full']
    # @param [String] capacity (in bytes)
    # @param [OneviewSDK::StoragePool] storage_pool
    def set_provisioning(shareable, provisionType, capacity, storage_pool)
      @data['provisioning']['shareable'] = shareable
      @data['provisioning']['provisionType'] = provisionType
      @data['provisioning']['capacity'] = capacity
      storage_pool.retrieve! unless storage_pool['uri']
      @data['provisioning']['storagePoolUri'] = storage_pool['uri']
    end

    # Set storage system
    # @param [OneviewSDK::StorageSystem] storage_system Storage System to be used to create the template
    def set_storage_system(storage_system)
      storage_system.retrieve! unless storage_system['uri']
      @data['storageSystemUri'] = storage_system['uri']
    end

    # Set snapshot pool
    # @param [OneviewSDK::StoragePool] storage_pool Storage Pool to generate the template
    def set_snapshot_pool(storage_pool)
      storage_pool.retrieve! unless storage_pool['uri']
      @data['snapshotPoolUri'] = storage_pool['uri']
    end

    # Get connectable volume templates by its attributes
    # @param [Hash] attributes Hash containing the attributes name and value
    def get_connectable_volume_templates(attributes = {})
      OneviewSDK::Resource.find_by(@client, attributes, BASE_URI + '/connectable-volume-templates')
    end

  end
end
