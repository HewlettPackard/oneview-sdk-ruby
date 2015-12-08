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
    PROVISIONING_PARAMETERS_LIST = %w(provisionType requestedCapacity shareable storagePoolUri)

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
    end

    # It's possible to create the volume in 6 different ways:
    # 1) Common = Storage System + Storage Pool
    # 2) Template = Storage Volume Template
    # 3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool
    # 4) Management = Storage System + wwn
    # 5) Management by name = Storage System + Storage System Volume Name
    # 6) Snapshot = Snapshot Pool + Storage Pool + Snapshot
    def create
      super
    end

    # Set a resource attribute with the given value and call any validation method if necessary
    # @param [String] key attribute name
    # @param value value to assign to the given attribute
    # @note Keys will be converted to strings
    # @override Some params are redirected to nested hash inside options
    def set(key, value)
      method_name = "validate_#{key}"
      send(method_name.to_sym, value) if self.respond_to?(method_name.to_sym)
      if PROVISIONING_PARAMETERS_LIST.include?(key.to_s)
        @data['provisioningParameters'] = {} unless @data['provisioningParameters']
        @data['provisioningParameters'][key.to_s] = value
      else
        @data[key.to_s] = value
      end
    end

    def add_storage_system(storage_system)
    end

    def add_storage_pool(storage_pool)
    end

    def set_storage_volume_template(storage_volume_template)
    end

    def add_snapshot_pool(storage_pool)
    end

    def add_snapshot(storage_volume_snapshot)
    end

    def validate_fabricType(value)
      fail 'Invalid fabric type' unless %w(DirectAttach FabricAttach).include?(value)
    end

    def validate_linkStabilityTime(value)
      return unless @data['fabricType'] && @data['fabricType'] == 'FabricAttach'
      fail 'Link stability time out of range 1..1800' unless value.between?(1, 1800)
    end

  end
end
