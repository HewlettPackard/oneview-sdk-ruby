module OneviewSDK
  # Resource for server hardware
  # Common Data Attributes:
  #   description
  #   isPermanent
  #   name
  #   provisioningParameters
  #     provisionType
  #     requestedCapacity
  #     shareable
  #     storagePoolUri
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
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['provisioningParameters'] ||= {}
    end

    # Adds storage system to the volume creation
    # @param [OneviewSDK::Resource] Storage system to create the volume
    def add_storage_system(storage_system)
      assure_uri(storage_system)
      @data['storageSystemUri'] = storage_system['uri']
    end

    # Adds storage pool to the volume creation inside provisioningParameters
    # @param [OneviewSDK::Resource] Storage pool to create the volume
    def add_storage_pool(storage_pool)
      assure_uri(storage_pool)
      @data['provisioningParameters']['storagePoolUri'] = storage_pool['uri']
    end

    # Adds storage volume template  to the volume creation
    # @param [OneviewSDK::Resource] Storage volume template to create the volume
    def set_storage_volume_template(storage_volume_template)
      assure_uri(storage_volume_template)
      @data['templateUri'] = storage_volume_template['uri']
    end

    # Adds snapshot pool to the volume creation
    # @param [OneviewSDK::Resource] Snapshot pool to create the volume
    def add_snapshot_pool(storage_pool)
      assure_uri(storage_pool)
      @data['snapshotPoolUri'] = storage_pool['uri']
    end

    def add_snapshot(storage_volume_snapshot)
      # TODO, Need sub-resource snapshot
    end

    # Defines the volume capacity
    # @param [Fixnum] The required capacity in Bytes.
    def set_requested_capacity(capacity)
      @data['provisioningParameters']['requestedCapacity'] = capacity
    end

    # Defines the type of provisioning
    # @param [String] The desired provisioning type. Must be Thin or Full. Default is Full.
    def set_provision_type(type = 'Full')
      validate_provisionType(type)
      @data['provisioningParameters']['provisionType'] = type
    end

    # Defines the type of provisioning
    # @param [FalseClass|TrueClass] The shareability of the volume. Default is true.
    def set_shareable(share = true)
      @data['provisioningParameters']['shareable'] = share
    end

    # Validation methods

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
