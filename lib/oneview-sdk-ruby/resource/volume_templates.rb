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
  #   refreshState
  #   state
  #   stateReason
  #   status
  #   storageSystemUri
  #   type
  #   uri
  class VolumeTemplate < Resource
    BASE_URI = '/rest/storage-volume-templates'

    def initialize(client, params = {}, api_ver = nil)
      @data = {}
      @data['provisioning'] = {}
      super

      # Default values:
      @data['type'] ||= 'StorageVolumeTemplateV3'
    end

    # Validate refreshState
    # @param [String] value NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    def validate_refreshState(value)
      fail 'Invalid refresh state' unless %w(NotRefreshing RefreshFailed RefreshPending Refreshing).include?(value)
    end

    # Validate status
    # @param [String] value OK, Disabled, Warning, Critical, Unknown
    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

    # Validate provisionType
    # @param [String] value Full, Thin
    def validate_provisionType(value)
      fail 'Invalid provisionType' unless %w(Full Thin).include?(value)
    end

    # Create the resource on OneView using the current data
    # @note Calls refresh method to set additional data
    # @raise [RuntimeError] if the client is not set
    # @raise [RuntimeError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'Accept-Language' => 'en_US', 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Delete volume template from OneView
    # @return [true] if volume template was deleted successfully
    def delete
      ensure_client && ensure_uri
      response = @client.rest_delete(@data['uri'], { 'Accept-Language' => 'en_US' }, @api_version)
      @client.response_handler(response)
      true
    end

    # Set a resource attribute with the given value and call any validation method if necessary,
    # fill the nested attributes automatically for provisioning
    # @param [String] key attribute name
    # @param value value to assign to the given attribute
    # @note Keys will be converted to strings
    def set(key, value)
      if %w(capacity provisionType shareable storagePoolUri).include?(key.to_s)
        method_name = "validate_#{key}"
        send(method_name.to_sym, value) if self.respond_to?(method_name.to_sym)
        @data['provisioning'][key] = value
      else
        super
      end
    end

    # Set storage pool
    # @param [StoragePool]
    def set_storage_pool(storage_pool)
      @data['provisioning']['storagePoolUri'] = storage_pool[:uri]
    end

    # Set storage system
    # @param [StorageSystem]
    def set_storage_system(storage_system)
      @data['storageSystemUri'] = storage_system[:uri]
    end

    # Set snapshot pool
    # @param [SnapshotPool]
    def set_snapshot_pool(storage_pool)
      @data['snapshotPoolUri'] = storage_pool[:uri]
    end

  end
end
