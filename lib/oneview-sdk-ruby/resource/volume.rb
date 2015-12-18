module OneviewSDK
  # Resource for server hardware
  # Common Data Attributes:
  #   description
  #   isPermanent
  #   name
  #   requestedCapacity (for creation only)
  #   provisionType
  #   shareable
  #   storagePoolUri
  #   snapshotPoolUri1
  #   snapshotUri
  #   storageSystemUri
  #   storageSystemVolumeName
  #   templateUri
  #   wwn
  class Volume < Resource
    BASE_URI = '/rest/storage-volumes'

    # It's possible to create the volume in 6 different ways:
    # 1) Common = Storage System + Storage Pool
    # 2) Template = Storage Volume Template
    # 3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool
    # 4) Management = Storage System + wwn
    # 5) Management by name = Storage System + Storage System Volume Name
    # 6) Snapshot = Snapshot Pool + Storage Pool + Snapshot

    def create
      @data['provisioningParameters'] ||= {}
      %w(storagePoolUri requestedCapacity provisionType shareable).each do |k|
        @data['provisioningParameters'][k] ||= @data.delete(k) if @data.key?(k)
      end
      super
      @data.delete('provisioningParameters')
      self
    end

    # Delete resource from OneView only (not from storage system)
    # @return [true] if resource was deleted successfully
    def delete_from_oneview
      ensure_client && ensure_uri
      response = @client.rest_api(:delete, @data['uri'], { 'exportOnly' => true }, @api_version)
      @client.response_handler(response)
      true
    end

    # Sets the storage system to the volume
    # @param [OneviewSDK::StorageSystem] Storage System
    def set_storage_system(storage_system)
      assure_uri(storage_system)
      @data['storageSystemUri'] = storage_system['uri']
    end

    # Sets the storage pool to the volume
    # @param [OneviewSDK::StoragePool] Storage pool
    def set_storage_pool(storage_pool)
      assure_uri(storage_pool)
      set('storagePoolUri', storage_pool['uri'])
    end

    # Adds storage volume template to the volume
    # @param [OneviewSDK::Resource] Storage Volume Template
    def set_storage_volume_template(storage_volume_template)
      assure_uri(storage_volume_template)
      set('templateUri', storage_volume_template['uri'])
    end

    # Sets the snapshot pool to the volume
    # @param [OneviewSDK::StoragePool] Storage Pool to use for snapshots
    def set_snapshot_pool(storage_pool)
      assure_uri(storage_pool)
      set('snapshotPoolUri', storage_pool['uri'])
    end

    # def add_snapshot(storage_volume_snapshot)
    #   TODO: Need sub-resource snapshot
    # end

    # Defines the volume capacity
    # @param [Fixnum] The required capacity in Bytes.
    def set_requested_capacity(capacity)
      set('requestedCapacity', capacity)
    end


    # Validation methods:

    # Validate the type of provisioning
    # @param [String] Must be Thin or Full
    def validate_provisionType(value)
      fail 'Invalid provision type' unless %w(Thin Full).include?(value)
    end

    private

    # Verify if the resource has a URI
    # If not, first it tries to retrieve, and then verify for its existence
    def assure_uri(resource)
      resource.retrieve! unless resource['uri']
      fail "#{resource.class}: #{resource['name']} not found" unless resource['uri']
    end

  end
end
